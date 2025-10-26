# NetOpsResilienceKit

A toolkit to validate Kubernetes network service resilience using Chaos Engineering and Robot Framework.

## How It Works

1. Deploy sample pod (`dns-pod-1`)
2. Simulate failure manually: `kubectl delete pod dns-pod-1`
3. Run Robot test to validate recovery
4. Automate with GitHub Actions

## Folder Structure

- `manifests/`: Pod manifests
- `robot-tests/`: Robot Framework test cases
- `scripts/`: Utility scripts
- `docs/`: Architecture and usage guides 


## 🔥 Install Chaos Mesh via Helm
1. Add the Chaos Mesh Helm repo

helm repo add chaos-mesh https://charts.chaos-mesh.org
helm repo update

2. Install Chaos Mesh
helm install chaos-mesh chaos-mesh/chaos-mesh \
  --namespace=chaos-mesh --create-namespace \
  --set chaosDaemon.runtime=containerd \
  --set chaosDaemon.socketPath=/run/containerd/containerd.sock

If you're using Docker runtime, remove the --set flags.

3. Verify Installation
kubectl get pods -n chaos-mesh
kubectl get crds | grep chaos-mesh


Expected CRDs:
podchaos.chaos-mesh.org
networkchaos.chaos-mesh.org
stresschaos.chaos-mesh.org
...

running pods like 
chaos-controller-manager
chaos-daemon


