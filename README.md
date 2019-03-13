# rawr

# Overview

## Opinionated network architecture

## Opinionated kubernetes architecture

## Prerequisites

Create a `local-config.mk` file in the base directory to override the required make parameters

```
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

```
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

## Verifying things are working

I typically install kubernetes  with kubespray and a slightly modified dynamic inventory script that connects to the public ips over ssh but uses the private hostnames in the inventory.

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