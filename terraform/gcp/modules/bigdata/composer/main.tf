resource "google_composer_environment" "main" {
  provider = google-beta

  name    = var.config.name
  region  = var.region
  labels  = var.labels
  project = var.project

  config {
    node_count = var.config.node_count

    node_config {
      zone            = var.zone
      machine_type    = var.config.machine_type
      network         = var.config.network
      subnetwork      = var.config.subnetwork
      disk_size_gb    = var.disk_size_gb
      oauth_scopes    = var.oauth_scopes
      service_account = var.service_account
      tags            = var.tags
    }

    dynamic "software_config" {
      for_each = var.software_config != null ? [var.software_config] : []
      iterator = _conf

      content {
        airflow_config_overrides = _conf.value.airflow_config_overrides
        pypi_packages            = _conf.value.pypi_packages
        env_variables            = _conf.value.env_variables
        image_version            = _conf.value.image_version
        python_version           = _conf.value.python_version
      }
    }

    dynamic "database_config" {
      for_each = var.database_config != null ? [var.database_config] : []
      iterator = _conf

      content {
        machine_type = _conf.value.machine_type
      }
    }
  }
}
