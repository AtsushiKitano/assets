locals {
  default_node_pool_management = {
    auto_repair  = true
    auto_upgrade = true
  }

  default_node_pool_autoscaling = {
    min_node_count = 1
    max_node_count = 2
  }

  default_node_pool_upgrade = {
    max_surge       = 10
    max_unavailable = 10
  }

  default_node_pool_oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
}

resource "google_container_cluster" "main" {
  provider                 = google-beta
  project                  = var.project
  name                     = var.cluster.name
  location                 = var.cluster.location
  cluster_ipv4_cidr        = var.cluster.networking_mode == "ROUTES" ? var.cluster.cluster_ipv4_cidr : null
  networking_mode          = var.cluster.networking_mode
  network                  = var.cluster.network
  subnetwork               = var.cluster.subnetwork
  remove_default_node_pool = var.remove_default_node_pool
  initial_node_count       = var.initial_node_count

  dynamic "release_channel" {
    for_each = var.release_channel != null ? [var.release_channel] : []
    iterator = _conf

    content {
      channel = _conf.value
    }
  }

  dynamic "workload_identity_config" {
    for_each = var.identity_namespace != null ? [var.identity_namespace] : []
    iterator = _conf

    content {
      identity_namespace = join(".", [
        data.google_project.main.project_id,
        _conf.value
      ])
    }
  }

  pod_security_policy_config {
    enabled = var.pod_security_policy_config
  }

  dynamic "master_authorized_networks_config" {
    for_each = length(var.master_authorized_networks_config) > 0 ? ["enable"] : []
    content {
      dynamic "cidr_blocks" {
        for_each = var.master_authorized_networks_config
        iterator = _conf

        content {
          display_name = _conf.value.display_name
          cidr_block   = _conf.value.cidr_block
        }
      }
    }
  }

  dynamic "cluster_autoscaling" {
    for_each = var.cluster_autoscaling != null ? [var.cluster_autoscaling] : []
    iterator = _conf

    content {
      enabled = _conf.value.enabled

      dynamic "resource_limits" {
        for_each = _conf.value.resource_limits != null ? [_conf.value.resource_limits] : []
        iterator = _v

        content {
          resource_type = _v.value.resource_type
          minimum       = _v.value.minimum
          maximum       = _v.value.maximum
        }
      }

      dynamic "auto_provisioning_defaults" {
        for_each = _conf.value.auto_provisioning_defaults != null ? [_conf.value.auto_provisioning_defaults] : []
        iterator = _v

        content {
          min_cpu_platform = _v.value.cluster_autoscaling.min_cpu_platform
          service_account  = _v.value.service_account
        }
      }
    }
  }

  dynamic "ip_allocation_policy" {
    for_each = var.cluster.networking_mode == "VPC_NATIVE" && var.ip_ranges != null ? [var.ip_ranges] : []
    iterator = _conf
    content {
      cluster_ipv4_cidr_block  = _conf.value.cluster
      services_ipv4_cidr_block = _conf.value.services
    }
  }

  dynamic "private_cluster_config" {
    for_each = var.cluster.networking_mode == "VPC_NATIVE" ? ["enable"] : []
    content {
      enable_private_endpoint = var.private_endpoint
      enable_private_nodes    = var.private_nodes

      dynamic "master_global_access_config" {
        for_each = var.master_global_access_config ? ["enable"] : []

        content {
          enabled = var.master_global_access_config
        }
      }
      master_ipv4_cidr_block = var.cluster.master_ipv4_cidr_block
    }
  }
}

resource "google_container_node_pool" "main" {
  for_each = { for v in var.node_pool : v.name => v }

  project            = var.project
  name               = each.value.name
  cluster            = google_container_cluster.main.name
  location           = each.value.location
  initial_node_count = each.value.initial_node_count
  node_count         = var.node_pool_autoscaling != null ? var.node_count : null
  max_pods_per_node  = var.cluster.networking_mode == "VPC_NATIVE" ? var.node_pool_max_pods : null
  node_locations     = each.value.node_locations
  name_prefix        = var.name_prefix != null ? lookup(var.name_prefix, each.value.name, null) : null
  version            = var.node_version != null ? lookup(var.node_version, each.value.name, null) : null

  dynamic "autoscaling" {
    for_each = var.node_pool_autoscaling != null ? [lookup(var.node_pool_autoscaling, each.value.name, local.default_node_pool_autoscaling)] : []
    iterator = _config

    content {
      min_node_count = _config.value.min_node_count
      max_node_count = _config.value.max_node_count
    }
  }

  dynamic "upgrade_settings" {
    for_each = var.node_pool_upgrade != null ? [lookup(var.node_pool_upgrade, each.value.name, local.default_node_pool_upgrade)] : []
    iterator = _config

    content {
      max_surge       = _config.value.max_surge
      max_unavailable = _config.value.max_unavailable
    }
  }

  node_config {
    disk_size_gb    = each.value.disk_size_gb
    disk_type       = each.value.disk_type
    image_type      = each.value.image_type
    machine_type    = each.value.machine_type
    service_account = var.service_account
    oauth_scopes    = var.node_pool_oauth_scopes != null && var.service_account != null ? lookup(var.node_pool_oauth_scopes, each.value.name, local.default_node_pool_oauth_scopes) : local.default_node_pool_oauth_scopes
    tags            = each.value.tags
    preemptible     = var.preemptible != null ? lookup(var.preemptible, each.value.name, null) : null
  }

  dynamic "management" {
    for_each = var.management != null ? [lookup(var.management, each.value.name, local.default_node_pool_management)] : [local.default_node_pool_management]
    iterator = _conf

    content {
      auto_repair  = _conf.value.auto_repair
      auto_upgrade = _conf.value.auto_upgrade
    }
  }
}
