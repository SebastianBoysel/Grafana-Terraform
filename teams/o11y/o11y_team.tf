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

variable "shared_dashboards" {
  type = list(string)
}

variable "ds_prometheus" {
  type        = string
  description = "UID of the Prometheus datasource in Grafana"
}

locals {
  # Team-specific dashboards (*.json) in teams/o11y/dashboards
  team_dashboards = fileset("${path.module}/dashboards", "*.json")

  team_dashboard_paths = [
    for f in local.team_dashboards :
    "${path.module}/dashboards/${f}"
  ]

  # Render shared NodeExporter template with O11Y-specific UID/title
  nodeexporter_o11y_config = templatefile(
    "${path.module}/../shared/dashboards/nodeexporter.json.tmpl",
    {
      uid           = "nodeexporter-o11y"
      title         = "Node Exporter"
      ds_prometheus = var.ds_prometheus
    }
  )

  team_alert_files = []
}

module "o11y_folder" {
  source = "../../modules/folder"
  title  = "o11y"
}

# Normal JSON-on-disk dashboards (team + shared)
module "o11y_dashboards" {
  source = "../../modules/dashboards"

  folder_uid = module.o11y_folder.uid

  dashboard_files = concat(
    var.shared_dashboards,
    local.team_dashboard_paths,
  )
}

# Templated NodeExporter dashboard for O11Y
resource "grafana_dashboard" "nodeexporter_o11y" {
  config_json = local.nodeexporter_o11y_config
  folder      = module.o11y_folder.uid
}

module "o11y_alerts" {
  source = "../../modules/alerts"

  folder_uid  = module.o11y_folder.uid
  alert_files = local.team_alert_files
}