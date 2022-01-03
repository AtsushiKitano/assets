resource "google_cloudbuild_trigger" "main" {
  name            = var.build_trigger.name
  description     = var.build_trigger_description
  service_account = var.build_trigger.service_account
  filename        = var.build_trigger.filename
  ignored_files   = var.build_trigger_ignored_files
  included_files  = var.build_trigger_included_files
  project         = var.project

  build {
    source {
      dynamic "storage_source" {
        for_each = var.storage_source != null ? toset(["dummy"]) : []

        content {
          bucket     = var.storage_source.bucket
          object     = var.storage_source.object
          generation = var.storage_source.generation
        }
      }

      dynamic "repo_source" {
        for_each = var.repo_source != null ? toset(["dummy"]) : []

        content {
          project_id  = var.project_id
          repo_name   = var.repo_source.repo_name
          branch_name = var.repo_source.branch_name
          tag_name    = var.repo_source.tag_name
        }
      }
    }

    options {
      worker_pool = google_cloud_build_worker_pool.main.id
    }
  }
}

resource "google_cloud_build_worker_pool" "main" {
  name     = each.value.name
  location = each.value.location
  project  = var.project

  dynamic "network_config" {
    for_each = var.network_config != null ? toset(["dummy"]) : []

    content {
      peered_network = var.network_config.peered_network
    }
  }

  dynamic "worker_config" {
    for_each = var.worker_config != null ? toset(["dymmy"]) : []

    content {
      disk_size_gb   = var.worker_config.disk_size_gb
      machine_type   = var.worker_config.machine_type
      no_external_ip = var.worker_config.no_external_ip
    }
  }
}
