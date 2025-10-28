# Check if Chaos Mesh is installed
if (-not (kubectl get ns chaos-mesh -o name 2>$null)) {
    Write-Host "Chaos Mesh not found. Installing via Helm..."
    helm repo add chaos-mesh https://charts.chaos-mesh.org
    helm repo update
    helm install chaos-mesh chaos-mesh/chaos-mesh --namespace=chaos-mesh --create-namespace
    Start-Sleep -Seconds 10
}

# Create namespace
kubectl create namespace chaos-testing --dry-run=client -o yaml | kubectl apply -f -

# Deploy busybox
kubectl apply -f manifests/busybox-deployment.yaml
kubectl rollout status deployment/busybox -n -A

# Apply recurring chaos experiment
kubectl apply -f chaosmesh/experiments/busybox-schedule.yaml

# Confirm schedule is active
Write-Host "`n✅ Chaos schedule deployed:"
kubectl get schedule -n chaos-testing

# Run Robot test
Write-Host "`n🤖 Running recovery test..."
robot robot-tests/test-cases/test_busybox_recovery.robot
