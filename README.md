# crtsh-kubernetes

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/crtsh-kubernetes)](https://artifacthub.io/packages/helm/crtsh-kubernetes/crtsh-kubernetes)

> [crt.sh](https://crt.sh/) allows users to search and monitor SSL/TLS certificates issued for domains **publicly**.

Deploy a [Prometheus Exporter for crt.sh](https://github.com/DazWilkin/crtsh-exporter/) — a [Certificate Transparency](https://certificate.transparency.dev/) log monitoring tool — on Kubernetes. 

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

### 2.1 Set domains for Certificate Expiry

crtsh exporter will scrape the crt.sh for the domains set in the `hosts` variable.

```yaml
hosts:
  - your-domain.com
  - your-cool-domain.io
```

### 2.2 Set Alert severity and timing

```yaml
prometheusRules:
  enabled: true
  expiringInfo:
    days: 90
    severity: info
  expiringWarning:
    days: 60
    severity: warning
  expiringCritical:
    days: 30
    severity: critical
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

## Credits
- [github.com/DazWilkin](https://github.com/DazWilkin) awesome humanbeing 
    - [DazWilkin/crtsh-exporter](https://github.com/DazWilkin/crtsh-exporter/) prometheus exporter written in go
