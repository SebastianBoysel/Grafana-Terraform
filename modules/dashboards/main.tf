terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = ">= 2.8.0"
    }
    local = {
      source = "hashicorp/local"
    }
  }
}

variable "folder_uid" {
  type        = string
}

variable "dashboard_files" {
  type        = list(string)
}

data "local_file" "dash" {
  for_each = { for f in var.dashboard_files : f => f }
  filename = each.key
}

resource "grafana_dashboard" "this" {
  for_each    = data.local_file.dash
  config_json = each.value.content
  folder      = var.folder_uid
}
