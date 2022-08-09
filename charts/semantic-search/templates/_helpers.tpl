{{/*
Expand the name of the chart.
*/}}
{{- define "semantic-search.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "semantic-search.fullname" -}}
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
{{- define "semantic-search.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "semantic-search.labels" -}}
helm.sh/chart: {{ include "semantic-search.chart" . }}
{{ include "semantic-search.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "semantic-search.selectorLabels" -}}
app.kubernetes.io/name: {{ include "semantic-search.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "semantic-search.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "semantic-search.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Generate a random password with length 32.
*/}}
{{- define "semantic-search.randomPassword" -}}
{{- randAlphaNum 32 -}}
{{- end }}

{{/*
Config checksum
*/}}
{{- define "semantic-search.configChecksum" }}
checksum/config: {{ cat (keys .Values.app.config | sortAlpha | toStrings | join "_") (values .Values.app.config | sortAlpha | toStrings | join "_") | sha256sum }}
{{- end }}
