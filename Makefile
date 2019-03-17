include config.mk

.DEFAULT_GOAL:=help

##@ Manage base stacks.
.PHONY: test_base
test_base: ## Test base stack.
	aws cloudformation validate-template --template-body file://stacks/base/cloudformation.yaml

.PHONY: deploy_base
deploy_base: ## Deploy the base stack.
	aws cloudformation deploy \
		--no-fail-on-empty-changeset \
		--capabilities CAPABILITY_NAMED_IAM \
		--template-file stacks/base/cloudformation.yaml \
		--stack-name $(ENVNAME) \
		--parameter-overrides \
			VpcCidrBlock=$(VPCCIDR) \
			CreatePrivateNetworks=$(PRIVATENETWORKING)

.PHONY: teardown_base
teardown_base: ## Teardown the base stack.
	aws cloudformation delete-stack --stack-name $(ENVNAME)
	# Wait for the stack to be torn down.
	aws cloudformation wait stack-delete-complete --stack-name $(ENVNAME)

##@ Manage k8s environments.
.PHONY: test_k8s
test_k8s: ## Test k8s stack.
	aws cloudformation validate-template --template-body file://stacks/k8s/cloudformation.yaml

.PHONY: deploy_k8s
deploy_k8s: ## Deploy the k8s stack.
	aws cloudformation deploy \
		--no-fail-on-empty-changeset \
		--capabilities CAPABILITY_NAMED_IAM \
		--template-file stacks/k8s/cloudformation.yaml \
		--stack-name $(NAME) \
		--parameter-overrides \
			EnvironmentName=$(ENVNAME) \
			KeyName=$(KEYNAME) \
			MasterImageId=$(MASTERIMAGEID) \
			WorkerImageId=$(WORKERIMAGEID) \
			InstanceType=$(INSTANCETYPE) \
			HostedZoneId=$(HOSTEDZONEID) \
			MasterNodeNetworkLoadBalancerAliasName=$(ELBNAME)

.PHONY: teardown_k8s
teardown_k8s: ## Teardown the k8s stack.
	aws cloudformation delete-stack --stack-name $(NAME)
	# Wait for the stack to be torn down.
	aws cloudformation wait stack-delete-complete --stack-name $(NAME)

##@ Manage eks environments.
.PHONY: test_eks
test_eks: ## Test eks stack.
	aws cloudformation validate-template --template-body file://stacks/eks/cloudformation.yaml

.PHONY: deploy_eks
deploy_eks: ## Deploy the eks stack.
	aws cloudformation deploy \
		--no-fail-on-empty-changeset \
		--capabilities CAPABILITY_NAMED_IAM \
		--template-file stacks/eks/cloudformation.yaml \
		--stack-name $(NAME) \
		--parameter-overrides \
			EnvironmentName=$(ENVNAME) \
			KeyName=$(KEYNAME) \
			ImageId=$(EKSIMAGEID) \
			InstanceType=$(EKSINSTANCETYPE)
			BootstrapArguments=$(BOOTSTRAPARGS)

.PHONY: teardown_eks
teardown_eks: ## Teardown the eks stack.
	aws cloudformation delete-stack --stack-name $(NAME)
	# Wait for the stack to be torn down.
	aws cloudformation wait stack-delete-complete --stack-name $(NAME)

##@ Help
.PHONY: help
help:  ## Type make followed by target you wish to run.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-z0-9A-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
