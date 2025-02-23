# crtsh-kubernetes

## Get the ServiceMonitor label

```bash
kubectl get prometheus -n monitoring -o go-template='{{range $k, $v := (index .items 0).spec.serviceMonitorSelector.matchLabels}}{{$k}}: {{$v}}{{end}}'
```

## Install with Helm

```bash
helm upgrade --install \
    -n crtsh --create-namespace \
    crtsh crtsh-kubernetes/ 
```

## Install with ArgoCD

```bash
```