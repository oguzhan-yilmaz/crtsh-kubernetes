


{{- define "crtsh-kubernetes.fetch-prometheus-objects" -}}
prometheusObjects:
{{ range $promObj := (lookup "monitoring.coreos.com/v1" "Prometheus" "" "").items }}
- {{ toYaml $promObj | nindent 2}}
{{ end }}  {{/* end of range promObj */}}
{{- end }} {{/* end of define */}}


{{- define "crtsh-kubernetes.prometheus" -}}
{{ $firstPromObj := first (include "crtsh-kubernetes.fetch-prometheus-objects" . | fromYaml).prometheusObjects -}}
{{ toYaml $firstPromObj }}
{{- end }} {{/* end of define */}}


{{- define "crtsh-kubernetes-service-monitor.labels" -}}
{{ $promObj :=  include "crtsh-kubernetes.prometheus" . | fromYaml -}}
{{ toYaml $promObj.spec.serviceMonitorSelector.matchLabels }}
{{- end }} {{/* end of define */}}


{{- define "crtsh-kubernetes.prometheus-namespace" -}}
{{ $promObj :=  include "crtsh-kubernetes.prometheus" . | fromYaml -}}
namespace: {{ $promObj.metadata.namespace }}
{{- end }} {{/* end of define */}}

{{- define "crtsh-kubernetes.prometheus-name" -}}
{{ $promObj :=  include "crtsh-kubernetes.prometheus" . | fromYaml -}}
name: {{ $promObj.metadata.name }}
{{- end }} {{/* end of define */}}