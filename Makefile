include config.mk

.DEFAULT_GOAL:=help

##@ Manage demo environments.
.PHONY: test
test: ## Test demo environment stack.
	aws cloudformation validate-template --template-body file://cloudformation.yaml

.PHONY: deploy
deploy: ## Deploy the demo environment stack.
	aws cloudformation deploy \
		--no-fail-on-empty-changeset \
		--capabilities CAPABILITY_NAMED_IAM \
		--template-file cloudformation.yaml \
		--stack-name $(NAME) \
		--parameter-overrides=EnvironmentType=$(ENV)

.PHONY: teardown
teardown: ## Teardown the demo environment stack.
	aws cloudformation delete-stack --stack-name $(NAME)
	# Wait for the stack to be torn down.
	aws cloudformation wait stack-delete-complete --stack-name $(NAME)

##@ Help
.PHONY: help
help:  ## Type make followed by target you wish to run.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-z0-9A-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
