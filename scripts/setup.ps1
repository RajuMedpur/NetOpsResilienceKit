# Check if Chaos Mesh is installed
if (-not (kubectl get ns chaos-mesh -o name 2>$null)) {
    Write-Host "Chaos Mesh not found. Installing via Helm..."
    helm repo add chaos-mesh https://charts.chaos-mesh.org
    helm repo update
    helm install chaos-mesh chaos-mesh/chaos-mesh --namespace=chaos-mesh --create-namespace
    Start-Sleep -Seconds 10
}

# Create namespace for chaos experiments
kubectl create namespace chaos-testing --dry-run=client -o yaml | kubectl apply -f -

# Deploy busybox pod via Deployment
kubectl apply -f manifests/busybox-deployment.yaml

# Wait for pod to be ready
Write-Host "Waiting for busybox pod to be ready..."
kubectl wait --for=condition=available --timeout=60s deployment/busybox -n chaos-testing

# Apply Chaos Mesh PodChaos experiment
kubectl apply -f chaosmesh/experiments/busybox-podchaos.yaml

# Confirm experiment was created
Write-Host "`n✅ Chaos experiment deployed:"
kubectl get podchaos -n chaos-testing
