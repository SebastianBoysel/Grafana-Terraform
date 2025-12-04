terraform {
  cloud {
    organization = "your-org-name"

    workspaces {
      name = "grafana-terraform"
    }
  }

  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = ">= 2.8.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.5.0"
    }
  }
}

provider "grafana" {
  url  = var.grafana_url
  auth = var.grafana_api_token
}

# Discover shared dashboards in teams/shared/dashboards/*.json
locals {
  shared_dashboards = fileset("${path.module}/teams/shared/dashboards", "*.json")
}

module "team_o11y" {
  source = "./teams/o11y"

  shared_dashboards = [
    for f in local.shared_dashboards :
    "${path.module}/teams/shared/dashboards/${f}"
  ]

  ds_prometheus = var.ds_prometheus
}

module "team_platform" {
  source = "./teams/platform"

  shared_dashboards = []

  ds_prometheus = var.ds_prometheus
}