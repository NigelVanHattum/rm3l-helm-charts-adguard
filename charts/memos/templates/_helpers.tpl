{{/*
Expand the name of the chart.
*/}}
{{- define "memos.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "memos.fullname" -}}
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
{{- define "memos.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "memos.labels" -}}
helm.sh/chart: {{ include "memos.chart" . }}
{{ include "memos.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "memos.selectorLabels" -}}
app.kubernetes.io/name: {{ include "memos.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "memos.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "memos.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{- define "memos.driver" -}}
{{- if .Values.mariadb.enabled }}
{{- printf "mysql" }}
{{- else if .Values.postgresql.enabled }}
{{- printf "postgres" }}
{{- else if .Values.sqlite.enabled }}
{{- printf "sqlite" }}
{{- end }}
{{- end }}

{{- define "memos.dsn" -}}
{{- if .Values.mariadb.enabled }}
{{- printf "%s:%s@tcp(%s-mariadb)/%s" .Values.mariadb.auth.username .Values.mariadb.auth.password .Release.Name .Values.mariadb.auth.database }}
{{- else if .Values.postgresql.enabled }}
{{- printf "postgresql://%s:%s@%s-postgresql:5432/%s?sslmode=disable" .Values.postgresql.auth.username .Values.postgresql.auth.password .Release.Name .Values.postgresql.auth.database}}
{{- else }}
{{- printf "" }}
{{- end }}
{{- end }}