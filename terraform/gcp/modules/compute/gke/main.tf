resource "google_container_cluster" "main" {
  name           = var.cluster_name
  project        = var.project
  location       = var.region
  node_locations = var.node_locations

  cluster_ipv4_cidr           = var.cluster_ipv4_cidr
  default_max_pods_per_node   = var.default_max_pods_per_node
  enable_binary_authorization = var.enable_binary_authorizajtion
  enable_tpu                  = var.enable_tpu
  enable_autopilot            = var.enable_autopilot
  networking_mode             = var.networking_mode
  remove_default_node_pool    = var.remove_default_node_pool
  logging_service             = var.logging_service
  network                     = var.network
  subnetwork                  = var.subnetwork

  dynamic "cluster_autoscaling" {
    for_each = var.cluster_autoscaling
    iterator = _config

    content {
      enabled = _config.value.enabled

      resource_limits {
        resource_type = _config.value.resource_type
        minimum       = _config.value.minimum
        maximum       = _config.value.maximum
      }
    }
  }

  dynamic "logging_config" {
    for_each = var.enable_components != null ? toset(["dummy"]) : []

    content {
      enable_components = var.enable_components
    }
  }

  workload_identity_config {
    workload_pool = format("%s.svc.id.goog", var.project)
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
    for_each = each.value.autoscaling
    iterator = _config

    content {
      min_node_count = _config.value.min_node_count
      max_node_count = _config.value.max_node_count
    }
  }

  dynamic "management" {
    for_each = each.value.management
    iterator = _config

    content {
      auto_repair  = _config.value.auto_repair
      auto_upgrade = _config.value.auto_upgrade
    }
  }

  dynamic "upgrade_settings" {
    for_each = each.value.upgrade_settings
    iterator = _config

    count {
      max_surge       = _config.value.max_surge
      max_unavailable = _config.value.max_unavailable
    }
  }
}
