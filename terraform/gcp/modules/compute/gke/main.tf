resource "google_container_cluster" "main" {
  name           = var.cluster_name
  project        = var.project
  location       = var.region
  node_locations = var.node_locations

  cluster_ipv4_cidr           = var.cluster_ipv4_cidr
  default_max_pods_per_node   = var.default_max_pods_per_node
  enable_binary_authorization = var.enable_binary_authorizajtion
  enable_tpu                  = var.enable_tpu
  networking_mode             = var.networking_mode
  remove_default_node_pool    = var.remove_default_node_pool
  logging_service             = var.logging_service
  network                     = var.network
  subnetwork                  = var.subnetwork
  initial_node_count          = var.initial_node_count

  dynamic "cluster_autoscaling" {
    for_each = var.cluster_autoscaling != null ? toset(["dummy"]) : []

    content {
      enabled = true

      resource_limits {
        resource_type = var.cluster_autoscaling.resource_type
        minimum       = var.cluster_autoscaling.minimum
        maximum       = var.cluster_autoscaling.maximum
      }
    }
  }

  dynamic "logging_config" {
    for_each = var.enable_components != null ? toset(["dummy"]) : []

    content {
      enable_components = var.enable_components
    }
  }

  dynamic "private_cluster_config" {
    for_each = var.private_cluster_config != null ? toset(["dummy"]) : []

    content {
      enable_private_nodes    = var.private_cluster_config.enable_private_nodes
      enable_private_endpoint = var.private_cluster_config.enable_private_endpoint
      master_ipv4_cidr_block  = var.private_cluster_config.master_ipv4_cidr_block
      master_global_access_config {
        enabled = var.private_cluster_config.master_global_access_config_enabled
      }
    }
  }

  workload_identity_config {
    workload_pool = format("%s.svc.id.goog", var.project)
  }

  dynamic "ip_allocation_policy" {
    for_each = var.networking_mode == "VPC_NATIVE" ? toset(["dummy"]) : []

    content {
      cluster_secondary_range_name  = var.cluster_secondary_range_name
      services_secondary_range_name = var.services_secondary_range_name
    }
  }

  dynamic "master_authorized_networks_config" {
    for_each = var.private_cluster_config.enable_private_endpoint ? toset(["dummy"]) : []

    content {
      dynamic "cidr_blocks" {
        for_each = var.master_authorized_networks_config.cidr_blocks
        iterator = _config

        content {
          cidr_block   = _config.value.cidr_block
          display_name = _config.value.display_name
        }
      }
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
  }
}

resource "google_container_node_pool" "main" {
  for_each = { for v in var.node_pools : v.name => v }

  cluster  = google_container_cluster.main.id
  location = var.region
  name     = each.value.name
  project  = var.project


  node_config {
    disk_size_gb    = each.value.disk_size_gb
    disk_type       = each.value.disk_type
    image_type      = each.value.image_type
    machine_type    = each.value.machine_type
    oauth_scopes    = contains(keys(var.oauth_scopes), each.value.name) ? var.oauth_scopes[each.value.name] : ["https://www.googleapis.com/auth/cloud-platform"]
    preemptible     = contains(var.preemptible_nodes, each.value.name)
    service_account = each.value.service_account
    tags            = each.value.tags
  }

  dynamic "autoscaling" {
    for_each = each.value.autoscaling != null ? toset(["dummy"]) : []

    content {
      min_node_count = each.value.autoscaling.min_node_count
      max_node_count = each.value.autoscaling.max_node_count
    }
  }

  dynamic "management" {
    for_each = each.value.management != null ? toset(["dummy"]) : []

    content {
      auto_repair  = each.value.management.auto_repair
      auto_upgrade = each.value.management.auto_upgrade
    }
  }

  dynamic "upgrade_settings" {
    for_each = each.value.upgrade_settings != null ? toset(["dummy"]) : []

    content {
      max_surge       = each.value.upgrade_settings.max_surge
      max_unavailable = each.value.upgrade_settings.max_unavailable
    }
  }
}
