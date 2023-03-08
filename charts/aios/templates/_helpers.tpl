{{/*
Expand the name of the chart.
*/}}
{{- define "aios.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "aios.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "aios.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "aios.labels" -}}
helm.sh/chart: {{ include "aios.chart" . }}
aios.dev/tenant-id: AIOS
{{ include "aios.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "aios.selectorLabels" -}}
app.kubernetes.io/name: {{ include "aios.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "aios.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "aios.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Generate a random password with length 32.
*/}}
{{- define "aios.randomPassword" -}}
{{- randAlphaNum 32 -}}
{{- end }}

{{/*
Config checksum
*/}}
{{- define "aios.configChecksum" }}
checksum/config: {{ cat (keys .Values.app.config | sortAlpha | toStrings | join "_") (values .Values.app.config | sortAlpha | toStrings | join "_") | sha256sum }}
{{- end }}

{{/*
AIOS URL
*/}}
{{- define "aios.url" }}
{{- $urlProtocol := "http" }}
{{- if .Values.ingress.tls }}
{{- $urlProtocol = "https" }}
{{- end }}
{{- $urlHost := "localhost" }}
{{- if .Values.ingress.hosts }}
{{- $urlHost = (first .Values.ingress.hosts).host }}
{{- end }}
{{- printf "%s://%s" $urlProtocol $urlHost }}
{{- end }}

{{/*
AIOS internal URL
*/}}
{{- define "aios.url-internal" }}
{{- printf "http://%s.%s:%s" (printf "%s-app" .Release.Name) (.Release.Namespace) ((int .Values.service.port | toString)) }}
{{- end }}

{{/*
AIOS Keycloak URL
*/}}
{{- define "aios.keycloak.url" }}
{{- $urlProtocol := "http" }}
{{- if .Values.keycloak.ingress.tls }}
{{- $urlProtocol = "https" }}
{{- end }}
{{- $urlHost := "localhost" }}
{{- if .Values.keycloak.ingress.hostname }}
{{- $urlHost = .Values.keycloak.ingress.hostname }}
{{- end }}
{{- printf "%s://%s" $urlProtocol $urlHost }}
{{- end }}

{{/*
AIOS Keycloak internal URL
*/}}
{{- define "aios.keycloak.url-internal" }}
{{- printf "http://%s:%s" (printf "%s-keycloak" .Release.Name) ((int .Values.keycloak.service.port | toString)) }}
{{- end }}

{{/*
AIOS Grafana URL
*/}}
{{- define "aios.grafana.url" }}
{{- $urlProtocol := "http" }}
{{- if .Values.kubeprometheusstack.grafana.ingress.tls }}
{{- $urlProtocol = "https" }}
{{- end }}
{{- $urlHost := "localhost" }}
{{- if .Values.kubeprometheusstack.grafana.ingress.hosts }}
{{- $urlHost = first .Values.kubeprometheusstack.grafana.ingress.hosts }}
{{- end }}
{{- printf "%s://%s" $urlProtocol $urlHost }}
{{- end }}

{{/*
AIOS Grafana internal URL
*/}}
{{- define "aios.grafana.url-internal" }}
{{- printf "http://%s:%s" (printf "%s-grafana" .Release.Name) ((int .Values.kubeprometheusstack.grafana.service.port | toString)) }}
{{- end }}

{{/*
AIOS Grafana Loki internal URL
*/}}
{{- define "aios.grafana.loki.url" }}
{{- printf "http://%s:%s" (printf "%s-loki" .Release.Name) (.Values.lokistack.loki.service.port | toString) }}
{{- end }}

{{/*
AIOS Prometheus URL
*/}}
{{- define "aios.prometheus.url" }}
{{- printf "http://%s:%s" (printf "%s-%s-prometheus" .Release.Name .Values.kubeprometheusstack.nameOverride) ((int .Values.kubeprometheusstack.prometheus.service.port | toString)) }}
{{- end }}
