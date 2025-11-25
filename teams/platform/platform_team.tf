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
  team_dashboards = fileset("${path.module}/dashboards", "*.json")

  team_dashboard_paths = [
    for f in local.team_dashboards :
    "${path.module}/dashboards/${f}"
  ]

  nodeexporter_platform_config = templatefile(
    "${path.module}/../shared/dashboards/nodeexporter.json.tmpl",
    {
      uid           = "nodeexporter-platform"
      title         = "Node Exporter"
      ds_prometheus = var.ds_prometheus
    }
  )

  team_alert_files = []
}

module "platform_folder" {
  source = "../../modules/folder"
  title  = "Platform"
}

module "platform_dashboards" {
  source = "../../modules/dashboards"

  folder_uid = module.platform_folder.uid

  dashboard_files = concat(
    var.shared_dashboards,
    local.team_dashboard_paths,
  )
}

resource "grafana_dashboard" "nodeexporter_platform" {
  config_json = local.nodeexporter_platform_config
  folder      = module.platform_folder.uid
}

module "platform_alerts" {
  source = "../../modules/alerts"

  folder_uid  = module.platform_folder.uid
  alert_files = local.team_alert_files
}