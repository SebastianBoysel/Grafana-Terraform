terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = ">= 2.8.0"
    }
  }
}

variable "folder_uid" {
  type        = string
}

variable "alert_files" {
  type        = list(string)
}
