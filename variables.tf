variable "grafana_url" {
  type        = string
}

variable "grafana_api_token" {
  type        = string
  sensitive   = true
}

variable "ds_loki" {
  type        = string
  sensitive   = true
}

variable "ds_prometheus" {
  type        = string
  sensitive   = true
}

variable "ds_tempo" {
  type        = string
  sensitive   = true
}
