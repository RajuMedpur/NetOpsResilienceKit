Write-Host "🚀 Starting NetOpsResilienceKit setup..."

# Step 1: Check for Helm
if (-not (Get-Command helm -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Helm not found. Please install Helm from https://helm.sh/docs/intro/install/"
    exit 1
}

# Step 2: Install LitmusChaos via Helm
Write-Host "📦 Installing LitmusChaos via Helm..."
helm repo add litmuschaos https://litmuschaos.github.io/litmus-helm/
helm repo update
helm install litmus litmuschaos/litmus --namespace=litmus --create-namespace

# Step 3: Wait for operator to initialize
Write-Host "⏳ Waiting for chaos-operator to be ready..."
Start-Sleep -Seconds 20

# Step 4: Deploy BusyBox target pod
Write-Host "📦 Deploying BusyBox pod via Deployment..."
kubectl apply -f manifests/busybox-deployment.yaml

# Step 5: Apply LitmusChaos RBAC
Write-Host "🔐 Applying LitmusChaos service account and RBAC..."
kubectl apply -f chaos/rbac/litmus-service-account.yaml

# Step 6: Apply ChaosEngine to trigger pod-delete experiment
Write-Host "🔥 Applying ChaosEngine for BusyBox pod-delete..."
kubectl apply -f chaos/engines/busybox-chaosengine.yaml

Write-Host "✅ Setup complete! Run Robot test with:"
Write-Host "robot robot-tests/test-cases/test_busybox_recovery.robot"
