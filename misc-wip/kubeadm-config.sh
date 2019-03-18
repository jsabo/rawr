KUBEADM_CONFIG="/tmp/kubeadm-config.yaml"
NODE_NAME=$(hostname -f)
POD_NETWORK="192.168.0.0/16"
SERVICE_NETWORK="10.96.0.0/12"

cat > ${KUBEADM_CONFIG} <<EOF
---
apiVersion: kubeadm.k8s.io/v1beta1
kind: ClusterConfiguration
apiServer:
  extraArgs:
    cloud-provider: aws
clusterName: kubernetes
controllerManager:
  extraArgs:
    cloud-provider: aws
    configure-cloud-routes: "false"
    address: 0.0.0.0
kubernetesVersion: v1.13.2
networking:
  dnsDomain: cluster.local
  podSubnet: POD_NETWORK
  serviceSubnet: SERVICE_NETWORK
scheduler:
  extraArgs:
    address: 0.0.0.0
---
apiVersion: kubeadm.k8s.io/v1beta1
kind: InitConfiguration
nodeRegistration:
  name: NODE_NAME
  kubeletExtraArgs:
    cloud-provider: aws
EOF

sed -i s/NODE_NAME/${NODE_NAME}/g ${KUBEADM_CONFIG}
sed -i s#POD_NETWORK#${POD_NETWORK}#g ${KUBEADM_CONFIG}
sed -i s#SERVICE_NETWORK#${SERVICE_NETWORK}#g ${KUBEADM_CONFIG}

sudo kubeadm init --config ${KUBEADM_CONFIG}
