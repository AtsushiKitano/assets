resource "google_container_cluster" "main" {
  provider = google-beta
  project  = var.project

  name        = var.cluster_name
  location    = var.region
  description = var.description

  # node pool configs
  remove_default_node_pool  = var.enable_autopilot == null ? var.remove_default_node_pool : null
  initial_node_count        = var.initial_node_count
  default_max_pods_per_node = var.networking_mode != "ROUTES" ? var.default_max_pods_per_node : null

  # network configs
  network         = var.network
  subnetwork      = var.subnetwork
  networking_mode = var.networking_mode

  # enablet configs
  enable_autopilot            = var.enable_autopilot
  enable_shielded_nodes       = var.enable_autopilot == null ? var.enable_shielded_nodes : null
  enable_tpu                  = var.enable_tpu
  enable_kubernetes_alpha     = var.enable_kubernetes_alpha
  enable_binary_authorization = var.enable_autopilot == null ? var.enable_binary_authorization : null

  dynamic "private_cluster_config" {
    for_each = var.private_cluster_config != null ? toset(["dummy"]) : []

    content {
      enable_private_nodes    = var.private_cluster_config.enable_private_nodes
      enable_private_endpoint = var.private_cluster_config.enable_private_endpoint
      master_ipv4_cidr_block  = var.private_cluster_config.master_ipv4_cidr_block
    }
  }

  dynamic "ip_allocation_policy" {
    for_each = var.networking_mode == "VPC_NATIVE" ? toset(["dummy"]) : []

    content {
      cluster_secondary_range_name  = var.cluster_secondary_range_name
      cluster_ipv4_cidr_block       = var.cluster_ipv4_cidr_block
      services_secondary_range_name = var.services_secondary_range_name
      services_ipv4_cidr_block      = var.services_ipv4_cidr_block
    }
  }

  dynamic "master_authorized_networks_config" {
    for_each = var.private_cluster_config != null ? toset(["dummy"]) : []

    content {
      dynamic "cidr_blocks" {
        for_each = var.master_authorized_networks_config_cidrs
        iterator = _config

        content {
          cidr_block   = _config.value.cidr_block
          display_name = _config.value.display_name
        }
      }
    }
  }

  addons_config {
    horizontal_pod_autoscaling {
      disabled = var.horizontal_pod_autoscaling
    }
  }

  dynamic "cluster_autoscaling" {
    for_each = length(var.cluster_autoscalings) > 0 ? toset(["dummy"]) : []

    content {
      enabled = true

      dynamic "resource_limits" {
        for_each = var.enable_autopilot == null ? var.cluster_autoscalings : []
        iterator = _config

        content {
          resource_type = _config.value.resource_type
          minimum       = _config.value.minimum
          maximum       = _config.value.maximum
        }
      }
    }
  }

  logging_service = var.logging_service
  dynamic "logging_config" {
    for_each = var.enable_components != null ? toset(["dummy"]) : []

    content {
      enable_components = var.enable_components
    }
  }

  dynamic "maintenance_policy" {
    for_each = var.enable_maintenance_policy ? toset(["dummy"]) : []

    content {
      dynamic "daily_maintenance_window" {
        for_each = var.daily_maintenance_window != null ? toset(["dummy"]) : []

        content {
          start_time = var.daily_maintenance_window.start_time
        }
      }

      dynamic "recurring_window" {
        for_each = var.recurring_window != null ? toset(["dummy"]) : []

        content {
          start_time = var.recurring_window.start_time
          end_time   = var.recurring_window.end_time
          recurrence = var.recurring_window.recurrence
        }
      }

      dynamic "maintenance_exclusion" {
        for_each = var.maintenance_exclusion
        iterator = _config

        content {
          exclusion_name = _config.value.exclusion_name
          start_time     = _config.value.start_time
          end_time       = _config.value.end_time
        }
      }
    }
  }

  dynamic "workload_identity_config" {
    for_each = var.enable_autopilot == null && length(var.workload_identity_config) > 0 ? toset(["dummy"]) : []
    content {
      workload_pool = format("%s.svc.id.goog", var.project)
    }
  }

  dynamic "dns_config" {
    for_each = var.dns_config != null ? toset(["dummy"]) : []

    content {
      cluster_dns        = var.dns_config.cluster_dns
      cluster_dns_scope  = var.dns_config.cluster_dns_scope
      cluster_dns_domain = var.dns_config.cluster_dns_domain
    }
  }

  dynamic "authenticator_groups_config" {
    for_each = var.google_workspace_domain != null ? toset(["dummy"]) : []

    content {
      security_group = format("gke-security-groups@%s", var.google_workspace_domain)
    }
  }

  lifecycle {
    ignore_changes = [
      initial_node_count
    ]
  }
}

resource "google_container_node_pool" "main" {
  provider = google-beta
  for_each = var.enable_autopilot == null ? { for v in var.node_pools : v.name => v } : {}

  name               = each.value.name
  location           = var.region
  cluster            = google_container_cluster.main.name
  project            = var.project
  initial_node_count = var.initial_node_count

  node_count = each.value.autoscaling == null ? var.node_count : null
  dynamic "autoscaling" {
    for_each = each.value.autoscaling != null ? toset(["dummy"]) : []

    content {
      min_node_count = each.value.autoscaling.min_node_count
      max_node_count = each.value.autoscaling.max_node_count
    }
  }

  node_config {
    preemptible     = each.value.preemptible
    machine_type    = each.value.machine_type
    disk_size_gb    = each.value.disk_size_gb
    disk_type       = each.value.disk_type
    service_account = each.value.service_account
    tags            = each.value.tags
    metadata        = each.value.metadata
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  lifecycle {
    ignore_changes = [
      initial_node_count
    ]
  }
}

resource "google_service_account_iam_member" "main" {
  count = length(var.workload_identity_config)

  service_account_id = var.workload_identity_config[count.index].service_account
  role               = "roles/iam.workloadIdentityUser"
  member             = format("serviceAccount:%s.svc.id.goog[%s/%s]", var.project, var.workload_identity_config[count.index].namespace, var.workload_identity_config[count.index].k8s_service_account)
}

resource "google_gke_hub_membership" "main" {
  for_each = var.enabled_multi_cluster ? toset([var.cluster_name]) : []

  membership_id = var.cluster_name
  project       = var.fleet_host_project != null ? var.fleet_host_project : var.project

  endpoint {
    gke_cluster {
      resource_link = google_container_cluster.main.id
    }
  }

  dynamic "authority" {
    for_each = length(workload_identity_config) > 0 ? ["dummy"] : []
    iterator = _config

    count {
      issuer = format("https://container.googleapis.com/v1/%s", google_container_cluster.main.id)
    }
  }
}
