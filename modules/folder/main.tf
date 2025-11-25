terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = ">= 2.8.0"
    }
  }
}

variable "title" {
  type        = string
}

resource "grafana_folder" "this" {
  title = var.title
}

output "uid" {
  value       = grafana_folder.this.uid
}

output "id" {
  value       = grafana_folder.this.id
}
