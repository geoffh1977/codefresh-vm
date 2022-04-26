#!/bin/bash

## Master Untaint
kubectl taint node $(hostname -s) node-role.kubernetes.io/master:NoSchedule-

## Calico
kubectl apply -f https://docs.projectcalico.org/manifests/tigera-operator.yaml

cat << EOF > /tmp/calico.yaml
---
apiVersion: operator.tigera.io/v1
kind: Installation
metadata:
  name: default
spec:
  # Configures Calico networking.
  calicoNetwork:
    # Note: The ipPools section cannot be modified post-install.
    ipPools:
    - blockSize: 26
      cidr: 10.244.0.0/16
      encapsulation: VXLANCrossSubnet
      natOutgoing: Enabled
      nodeSelector: all()
EOF

kubectl apply -f /tmp/calico.yaml

## MetalLB
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/metallb.yaml

cat << EOF > /tmp/config
address-pools:
  - name: default
    protocol: layer2
    avoid-buggy-ips: true
    addresses:
      - 192.168.122.224/28
EOF

kubectl -n metallb-system create cm config --from-file=/tmp/config

## NGINX Ingress
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.1.1/deploy/static/provider/baremetal/deploy.yaml


## Codefresh CLI
curl -L --output - https://github.com/codefresh-io/cli-v2/releases/latest/download/cf-linux-amd64.tar.gz | tar zx && mv ./cf-linux-amd64 /usr/local/bin/cf
