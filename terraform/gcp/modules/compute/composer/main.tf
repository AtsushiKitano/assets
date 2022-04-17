resource "google_composer_environment" "main" {
  name    = var.name
  region  = var.region
  project = var.project

  config {
    node_config {
      network         = var.network
      subnetwork      = var.subnetwork
      service_account = var.service_account

      ip_allocation_policy {
        cluster_secondary_range_name  = var.cluster_range_name
        services_secondary_range_name = var.service_range_name
      }
    }

    software_config {
      airflow_config_overrides = var.airflow_config_overrides
      pypi_packages            = var.pypi_packages
      env_variables            = var.env_variables
      image_version            = var.image_version
    }

    dynamic "private_environment_config" {
      for_each = var.enable_private_endpoint ? ["dummy"] : []

      content {
        enable_private_endpoint                = var.enable_private_endpoint
        master_ipv4_cidr_block                 = var.master_ipv4_cidr_block
        cloud_sql_ipv4_cidr_block              = var.cloud_sql_ipv4_cidr_block
        cloud_composer_network_ipv4_cidr_block = var.cloud_composer_network_ipv4_cidr_block
        cloud_composer_connection_subnetwork   = var.cloud_composer_connection_subnetwork
      }
    }

    dynamic "maintenance_window" {
      for_each = var.maintenance_window != null ? ["dummy"] : []

      content {
        start_time = var.maintenance_window.start_time
        end_time   = var.maintenance_window.end_time
        recurrence = var.maintenance_window.recurrence
      }
    }

    dynamic "workloads_config" {
      for_each = var.scheduler != null || var.web_server != null || var.worker != null ? ["dummy"] : []

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
            storage_gb = Var.worker.storage_gb
            min_count  = var.worker.min_count
            max_count  = var.worker.max_count
          }
        }
      }
    }
    environment_size = var.environment_size
  }
}
