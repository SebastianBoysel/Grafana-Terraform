variable "grafana_url" {
  type        = string
  description = "Base URL of the Grafana instance, e.g. https://your-stack.grafana.net/"
}

variable "grafana_api_token" {
  type        = string
  description = "Grafana service account token with admin-level permissions"
  sensitive   = true
}