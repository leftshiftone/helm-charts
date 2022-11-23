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
{{- printf "http://%s.%s:%s" (printf "%s-app" .Release.Name) (.Release.Namespace) ((int (first (first .Values.ingress.hosts).paths).port | toString)) }}
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
{{- $kubePrometheusStack := get .Values "kube-prometheus-stack" }}
{{- $urlProtocol := "http" }}
{{- if $kubePrometheusStack.grafana.ingress.tls }}
{{- $urlProtocol = "https" }}
{{- end }}
{{- $urlHost := "localhost" }}
{{- if $kubePrometheusStack.grafana.ingress.hosts }}
{{- $urlHost = first $kubePrometheusStack.grafana.ingress.hosts }}
{{- end }}
{{- printf "%s://%s" $urlProtocol $urlHost }}
{{- end }}

{{/*
AIOS Grafana internal URL
*/}}
{{- define "aios.grafana.url-internal" }}
{{- $kubePrometheusStack := get .Values "kube-prometheus-stack" }}
{{- printf "http://%s:%s" (printf "%s-grafana" .Release.Name) ((int $kubePrometheusStack.grafana.service.port | toString)) }}
{{- end }}

{{/*
AIOS Grafana Loki internal URL
*/}}
{{- define "aios.grafana.loki.url" }}
{{- $lokiStack := get .Values "loki-stack" }}
{{- printf "http://%s:%s" (printf "%s-loki" .Release.Name) ($lokiStack.loki.service.port | toString) }}
{{- end }}

{{/*
AIOS Prometheus URL
*/}}
{{- define "aios.prometheus.url" }}
{{- $kubePrometheusStack := get .Values "kube-prometheus-stack" }}
{{- printf "http://%s:%s" (printf "%s-%s-prometheus" .Release.Name $kubePrometheusStack.nameOverride) ((int $kubePrometheusStack.prometheus.service.port | toString)) }}
{{- end }}


{{/*
EMQX chart
*/}}

{{/*
EMQX: Expand the name of the chart.
*/}}
{{- define "emqx.name" -}}
emqx
{{- end }}

{{/*
EMQX: Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "emqx.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := "emqx" }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
EMQX: Create chart name and version as used by the chart label.
*/}}
{{- define "emqx.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
EMQX: Common labels
*/}}
{{- define "emqx.labels" -}}
helm.sh/chart: {{ include "emqx.chart" . }}
{{ include "emqx.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Values.emqx.image.tag | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
EMQX: Selector labels
*/}}
{{- define "emqx.selectorLabels" -}}
app.kubernetes.io/name: {{ include "emqx.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
EMQX: Create the name of the service account to use
*/}}
{{- define "emqx.serviceAccountName" -}}
{{- if .Values.emqx.serviceAccount.create }}
{{- default (include "emqx.fullname" .) .Values.emqx.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.emqx.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
EMQX: Config checksum
*/}}
{{- define "emqx.configChecksum" }}
checksum/config: {{ cat (keys .Values.emqx.config | sortAlpha | toStrings | join "_") (values .Values.emqx.config | sortAlpha | toStrings | join "_") | sha256sum }}
checksum/acl: {{ .Values.emqx.acl | sha256sum }}
{{- end }}

{{/*
EMQX: Return the proper Storage Class
{{ include "common.storage.class" ( dict "persistence" .Values.path.to.the.persistence "global" $) }}
*/}}
{{- define "emqx.storage.class" -}}

{{- $storageClass := .persistence.storageClass -}}
{{- if .global -}}
    {{- if .global.storageClass -}}
        {{- $storageClass = .global.storageClass -}}
    {{- end -}}
{{- end -}}

{{- if $storageClass -}}
  {{- if (eq "-" $storageClass) -}}
      {{- printf "storageClassName: \"\"" -}}
  {{- else }}
      {{- printf "storageClassName: %s" $storageClass -}}
  {{- end -}}
{{- end -}}

{{- end -}}

{{/*
EMQX: Renders a value that contains template.
{{ include "common.tplvalues.render" ( dict "value" .Values.path.to.the.Value "context" $) }}
*/}}
{{- define "emqx.tplvalues.render" -}}
    {{- if typeIs "string" .value }}
        {{- tpl .value .context }}
    {{- else }}
        {{- tpl (.value | toYaml) .context }}
    {{- end }}
{{- end -}}
