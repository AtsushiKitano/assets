resource "google_composer_environment" "main" {
  project = var.project
  name    = var.name
  labels  = var.labels
  region  = var.region

  config {
    environment_size = var.environment_size

    dynamic "web_server_network_access_control" {
      for_each = var.allowd_ip_ranges

      content {
        dynamic "allowed_ip_range" {
          for_each = var.allowd_ip_ranges
          iterator = _conf

          content {
            value       = _conf.value.ip_range
            description = _conf.value.description
          }
        }
      }
    }

    node_config {
      network         = data.google_compute_network.main.self_link
      subnetwork      = data.google_compute_subnetwork.main.self_link
      service_account = data.google_service_account.main.email

      ip_allocation_policy {
        cluster_secondary_range_name  = var.cluster_secondary_range_name
        services_secondary_range_name = var.services_secondary_range_name
      }
    }

    private_environment_config {
      enable_private_endpoint                = var.enable_private_endpoint
      master_ipv4_cidr_block                 = var.master_ipv4_cidr_block
      cloud_sql_ipv4_cidr_block              = var.cloud_sql_ipv4_cidr_block
      cloud_composer_network_ipv4_cidr_block = var.cloud_composer_network_ipv4_cidr_block
    }

    software_config {
      airflow_config_overrides = var.airflow_config_overrides
      image_version            = var.image_version
      env_variables            = var.env_variables
      pypi_packages            = var.pypi_packages
    }

    dynamic "workloads_config" {
      for_each = var.workload_config_enabled ? ["dummy"] : []

      content {
        dynamic "scheduler" {
          for_each = var.scheduler != null ? ["dummy"] : []

          content {
            cpu        = var.scheduler.cpu
            memory_gb  = var.scheduler.memory_gb
            storage_gb = var.scheduler.storage_gb
            count      = var.scheduler.count
          }
        }
        dynamic "web_server" {
          for_each = var.web_server != null ? ["dummy"] : []

          content {
            cpu        = var.web_server.cpu
            memory_gb  = var.web_server.memory_gb
            storage_gb = var.web_server.storage_gb
          }
        }
        dynamic "worker" {
          for_each = var.worker != null ? ["dummy"] : []

          content {
            cpu        = var.worker.cpu
            memory_gb  = var.worker.memory_gb
            storage_gb = var.worker.storage_gb
            min_count  = var.worker.min_count
            max_count  = var.worker.max_count
          }
        }
      }
    }

    dynamic "encryption_config" {
      for_each = var.enable_cmek ? toset(["cmek"]) : []

      content {
        kms_key_name = data.google_kms_crypto_key.main["cmek"].id
      }
    }
  }
}

data "google_kms_key_ring" "main" {
  for_each = var.enable_cmek ? toset(["cmek"]) : []

  name     = format("%s-%s", var.project, var.key_ring)
  location = var.key_location
  project  = var.key_project
}

data "google_kms_crypto_key" "main" {
  for_each = var.enable_cmek ? toset(["cmek"]) : []

  name     = var.name
  key_ring = data.google_kms_key_ring.main["cmek"].id
}

data "google_compute_network" "main" {
  name    = var.network
  project = var.project
}

data "google_compute_subnetwork" "main" {
  name    = var.subnetwork
  region  = var.region
  project = var.project
}
