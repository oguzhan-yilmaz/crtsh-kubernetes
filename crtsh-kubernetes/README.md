# [crtsh-kubernetes](https://github.com/oguzhan-yilmaz/crtsh-kubernetes)

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/crtsh-kubernetes)](https://artifacthub.io/packages/search?repo=crtsh-kubernetes)


Deploy a Prometheus Exporter for [crt.sh](https://crt.sh/) — a [Certificate Transparency](https://certificate.transparency.dev/) log monitoring tool — on Kubernetes. 

Includes Prometheus Rules for alerting expiring SSL certificates via AlertManager.


## 1. Add the Helm Repository

```bash
helm repo add crtsh-kubernetes https://oguzhan-yilmaz.github.io/crtsh-kubernetes

helm repo update crtsh-kubernetes
```

## 2. Update the helm values.yaml

First, save the default values to a file.

```bash
helm show values crtsh-kubernetes/crtsh-kubernetes > crtsh-values.yaml
```

### 2.1 Get the ServiceMonitor label

Prometheus has a configuration named `serviceMonitorSelector` and it's used to dynamically select `ServiceMonitor` objects to scrape.

It's usually the Helm Release name: `release: <your-prom-release-name>`

Each installation may differ, so use the below command to find out the correct label(s).

```bash
kubectl get prometheus -n monitoring -o go-template='{{range $k, $v := (index .items 0).spec.serviceMonitorSelector.matchLabels}}{{$k}}: {{$v}}{{end}}'
```

Update the `.serviceMonitorLabels` in `values.yaml` accordingly.

```yaml
serviceMonitorLabels:
  release: kube-prometheus-stack
```

### 2.2 Set domains for Certificate Expiry

crtsh exporter will scrape the crt.sh for the domains set in the `hosts` variable.

```yaml
hosts:
  - your-domain.com
  - your-cool-domain.io
```

## 3. Helm Install

```bash
helm upgrade --install crtsh \
    -n crtsh --create-namespace \
    -f crtsh-values.yaml \
    crtsh-kubernetes/crtsh-kubernetes
```

## 4. ArgoCD Install

You can use the `argocd-application.yaml` manifest in the Github repo: <https://github.com/oguzhan-yilmaz/crtsh-kubernetes/blob/main/argocd-application.yaml>

```bash
kubectl apply -f https://raw.githubusercontent.com/oguzhan-yilmaz/crtsh-kubernetes/refs/heads/main/argocd-application.yaml
```
