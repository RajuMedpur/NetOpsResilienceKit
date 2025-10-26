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


## 🔥 Chaos Setup with Litmus

To run chaos experiments:

```bash
kubectl apply -f litmus-chaos/crds/litmuschaos-crds.yaml
kubectl apply -f litmus-chaos/rbac/litmus-service-account.yaml
kubectl apply -f litmus-chaos/engines/dns-pod-delete-chaosengine.yaml
