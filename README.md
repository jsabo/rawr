# rawr

# Overview

Quickly spin up HA Kubernetes and EKS stacks using AWS Cloudformation and Ansible.

## AWS network architecture

The base networking environment consists of a VPC with IPv4 and IPv6 addressing for subnets across three availability zones. The IPv4 network cidr is configurable and the IPv6 cidr is dynamically assigned by AWS.  Private subnets with a NAT gateway per availability zone can optionally be created.  Security groups and IAM roles used by Kubernetes and EKS are also deployed as part of the base networking environment.

![network](images/vpc.png)

## Kubernetes cluster architecture

### K8s

User -> NLB -> 3 master/etcd nodes -> 3 worker nodes

### EKS

User -> AWS managed control plane -> 3 worker nodes

## Prerequisites

Install ansible.

```bash
brew install ansible
```

Install the awscli.

```bash
brew install awscli
```

Configure awscli credentials.

```bash
aws configure
```

Check to make sure you can authenticate to the AWS apis and you're in the right account.

```bash
aws sts get-caller-identity
```

Create a `local-config.mk` file in the base directory to override the required make parameters.

```bash
ENVNAME=sabo-demo
REGION=us-east-1
VPCCIDR=10.0.0.0/16
PRIVATENETWORKING=false
KEYNAME=sabo
MASTERIMAGEID=ami-0565af6e282977273
WORKERIMAGEID=ami-0565af6e282977273
INSTANCETYPE=t3.large
EKSIMAGEID=ami-0b4eb1d8782fc3aea
EKSINSTANCETYPE=t3.large
ELBNAME=k8s.example.com
HOSTEDZONEID=A1FI3N5HP7AV7F
```

# Usage

```bash
$ make

Usage:
  make <target>

Manage base stacks.
  test_base        Test base stack.
  deploy_base      Deploy the base stack.
  teardown_base    Teardown the base stack.

Manage k8s environments.
  test_k8s        Test k8s stack.
  deploy_k8s      Deploy the k8s stack.
  teardown_k8s    Teardown the k8s stack.

Manage eks environments.
  test_eks         Test eks stack.
  deploy_eks       Deploy the eks stack.
  teardown_eks     Teardown the eks stack.

Help
  help             Type make followed by target you wish to run.
```

## Setup base networking environment

Launch the supporting AWS network (VPC) and security resources (IAM, SGs).

[![Launch Stack](images/launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?templateURL=https://s3.amazonaws.com/tigera-solutions/rawr/stacks/base/cloudformation.yaml)


```bash
make deploy_base NAME=sabo-demo
```

## Deploying k8s stack

Launch the compute infrastructure for Kubernetes master and worker nodes.

[![Launch Stack](images/launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?templateURL=https://s3.amazonaws.com/tigera-solutions/rawr/stacks/k8s/cloudformation.yaml)

```bash
make deploy_k8s NAME=sabo-demo-k8s
```

## Installing Kubernetes

Let's install the Kubernetes software on the compute infrastructure we just launched.

### KubeAdm

#### Verifying things are working

### Kubespray

Refer to the [kubespray](https://github.com/kubernetes-sigs/kubespray/blob/master/docs/aws.md) docs for configuration

```bash
export REGION=us-east-1
export VPC_VISIBILITY=public
ansible-playbook -i inventory/kubespray-aws-inventory.py \
  --user ubuntu \
  --become \
  --become-user=root \
  cluster.yml
```

#### Verifying things are working

```bash
ansible kube-master -i inventory/kubespray-aws-inventory.py \
  --user ubuntu \
  --become \
  --become-user=root \
  -m shell -a "kubectl --kubeconfig /etc/kubernetes/admin.conf get nodes"
```

## Deploying EKS stack

Launch an AWS managed Kubernetes control plane and fully configured worker nodes.

[![Launch Stack](images/launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?templateURL=https://s3.amazonaws.com/tigera-solutions/rawr/stacks/eks/cloudformation.yaml)

```bash
make deploy_eks NAME=sabo-demo-eks
```

### Verifying things are working


## Tearing it down

If we want to start over with fresh compute resources we can quickly teardown the Kubernetes stacks while leaving the base networking environment alone.  When we're done and want to clean everything up we can tear it all down, including the base networking environment.

```bash
make teardown_k8s NAME=sabo-demo-k8s
```

```bash
make teardown_eks NAME=sabo-demo-eks
```

```bash
make teardown_base NAME=sabo-demo
```