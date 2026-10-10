{{- define "web-service.labels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "web-service.selectorLabels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
{{- end }}
