# rawr

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

## Make a `local-config.mk` to override some values

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