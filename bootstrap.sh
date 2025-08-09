#!/bin/bash

OLM_VERSION=${OLM_VERSION:-"0.32.0"}

echo "⚠️  This script will install the Operator Lifecycle Manager (OLM) and the ArgoCD operator"
echo "   Please make sure that you are allowed to run this on this cluster"
echo "   This process can cause disruption on your cluster"

echo "➡️ Starting deploy of OLM $OLM_VERSION"
curl -sL https://github.com/operator-framework/operator-lifecycle-manager/releases/download/v$OLM_VERSION/install.sh | bash -s v$OLM_VERSION


echo "➡️ Deploying ArgoCD"
kubectl create -f https://operatorhub.io/install/argocd-operator.yaml

sleep 3
kubectl get csv -n operators

# Deploy ArgoCD

kubectl apply -n operators -f- <<EOF

apiVersion: argoproj.io/v1beta1
kind: ArgoCD
metadata:
  name: argocd-gitops
spec: {}

EOF
