# rawr

# Overview

## AWS network architecture

## Kubernetes cluster architecture

## Prerequisites

Install ansible

```
brew install ansible
```

Install the awscli

```
brew install awscl
```

Configure awscli credentials

```
aws configure
```

Check to make sure you can authenticate to the AWS apis and you're in the right account

```
aws sts get-caller-identity
```

Create a `local-config.mk` file in the base directory to override the required make parameters

```console
$ cat local-config.mk
ENVNAME=sabo-demo
ELBNAME=k8s.example.com
HOSTEDZONEID=JDLSLSJSJSJS
KEYNAME=sabo
IMAGEID=ami-0565af6e282977273
INSTANCETYPE=t3.large
EKSINSTANCETYPE=t3.large
EKSIMAGEID=ami-0b4eb1d8782fc3aea
```

# Usage

```console
$ make

Usage:
  make <target>

Manage base stacks.
  test_base        Test base stack.
  deploy_base      Deploy the base stack.
  teardown_base    Teardown the base stack.

Manage tsee environments.
  test_tsee        Test tsee stack.
  deploy_tsee      Deploy the tsee stack.
  teardown_tsee    Teardown the tsee stack.

Manage eks environments.
  test_eks         Test eks stack.
  deploy_eks       Deploy the eks stack.
  teardown_eks     Teardown the eks stack.

Help
  help             Type make followed by target you wish to run.
```

## Setup base networking environment

```
make deploy_base NAME=sabo-demo
```

## Deploying tsee stack

```
make deploy_tsee NAME=sabo-demo-tsee
```

## Deploying eks stack

```
make deploy_eks NAME=sabo-demo-eks
```

## Installing Kubernetes

### Kubespray

Refer to the [kubespray](https://github.com/kubernetes-sigs/kubespray/blob/master/docs/aws.md) docs for configuration

```
VPC_VISIBILITY=public ansible-playbook -i inventory/kubespray-aws-inventory.py --user ubuntu --become --become-user=root cluster.yml
```

## Verifying things are working

```
$ VPC_VISIBILITY=public ansible kube-master -i inventory/kubespray-aws-inventory.py --user ubuntu --become --become-user=root -m shell -a "kubectl --kubeconfig /etc/kubernetes/admin.conf get nodes"
```

## Tearing it down

```
make teardown_tsee NAME=sabo-demo-tsee
```

```
make teardown_eks NAME=sabo-demo-eks
```

```
make teardown_base NAME=sabo-demo
```