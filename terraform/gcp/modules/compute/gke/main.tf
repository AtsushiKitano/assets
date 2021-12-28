resource "google_container_cluster" "main" {
  provider = google-beta
  project  = var.project

  name     = var.cluster_name
  location = var.region

  remove_default_node_pool = true
  initial_node_count       = 1

  network         = var.network
  subnetwork      = var.subnetwork
  networking_mode = "VPC_NATIVE"

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block  = "172.16.0.32/28"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = format("%s-%s", var.name, "pods")
    services_secondary_range_name = format("%s-%s", var.name, "services")
  }

  master_authorized_networks_config {}

  cluster_autoscaling {
    enabled             = true
    autoscaling_profile = "BALANCED"

    resource_limits {
      resource_type = "memory"
      minimum       = 1
      maximum       = 64
    }
    resource_limits {
      resource_type = "cpu"
      minimum       = 1
      maximum       = 10
    }
  }

  # dynamic "private_cluster_config" {
  #   for_each = var.private_cluster_config != null ? toset(["dummy"]) : []

  #   content {
  #     enable_private_nodes    = var.private_cluster_config.enable_private_nodes
  #     enable_private_endpoint = var.private_cluster_config.enable_private_endpoint
  #     master_ipv4_cidr_block  = var.private_cluster_config.master_ipv4_cidr_block
  #   }
  # }

  # dynamic "ip_allocation_policy" {
  #   for_each = var.networking_mode == "VPC_NATIVE" ? toset(["dummy"]) : []

  #   content {
  #     cluster_secondary_range_name  = var.cluster_secondary_range_name
  #     services_secondary_range_name = var.services_secondary_range_name
  #   }
  # }

  # dynamic "master_authorized_networks_config" {
  #   for_each = var.private_cluster_config != null ? toset(["dummy"]) : []

  #   content {
  #     dynamic "cidr_blocks" {
  #       for_each = var.master_authorized_networks_config_cidrs
  #       iterator = _config

  #       content {
  #         cidr_block   = _config.value.cidr_block
  #         display_name = _config.value.display_name
  #       }
  #     }
  #   }
  # }

  addons_config {
    horizontal_pod_autoscaling {
      disabled = true
    }
  }

  # dynamic "cluster_autoscaling" {
  #   for_each = length(var.cluster_autoscalings) > 0 ? toset(["dummy"]) : []

  #   content {
  #     enabled = true

  #     dynamic "resource_limits" {
  #       for_each = var.cluster_autoscalings
  #       iterator = _config

  #       content {
  #         resource_type = _config.value.resource_type
  #         minimum       = _config.value.minimum
  #         maximum       = _config.value.maximum
  #       }
  #     }
  #   }
  # }
}

resource "google_container_node_pool" "main" {
  provider = google-beta
  for_each = { for v in var.node_pools : v.name => v }

  name     = each.value.name
  location = var.region
  cluster  = google_container_cluster.main.name
  project  = var.project


  autoscaling {
    min_node_count = 0
    max_node_count = 2
  }

  node_config {
    preemptible  = true
    machine_type = "e2-medium"

    #service_account = each.value.service_account
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  # dynamic "autoscaling" {
  #   for_each = each.value.autoscaling != null ? toset(["dummy"]) : []

  #   content {
  #     min_node_count = each.value.autoscaling.min_node_count
  #     max_node_count = each.value.autoscaling.max_node_count
  #   }
  # }

  # node_config {
  #   preemptible     = each.value.preemptible
  #   machine_type    = each.value.machine_type
  #   service_account = each.value.service_account
  #   oauth_scopes = [
  #     "https://www.googleapis.com/auth/cloud-platform"
  #   ]
  # }
}
