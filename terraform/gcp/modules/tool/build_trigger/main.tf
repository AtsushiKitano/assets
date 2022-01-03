resource "google_cloudbuild_trigger" "main" {
  provider = google-beta

  name          = var.trigger.name
  filename      = var.trigger.filename
  substitutions = var.trigger.substitutions

  dynamic "trigger_template" {
    for_each = var.trigger_template != null && var.github == null ? [var.trigger_template] : []
    iterator = _conf

    content {
      repo_name    = google_sourcerepo_repository.main.name
      project_id   = var.project
      dir          = _conf.value.dir
      branch_name  = _conf.value.branch_name
      tag_name     = _conf.value.tag_name
      commit_sha   = _conf.value.commit_sha
      invert_regex = _conf.value.invert_regex
    }
  }

  dynamic "github" {
    for_each = var.trigger_template == null && var.github != null ? [var.github] : []
    iterator = _conf

    content {
      owner = _conf.value.owner
      name  = _conf.value.name

      dynamic "pull_request" {
        for_each = var.github_pr != null ? [var.github_pr] : []
        iterator = _var

        content {
          branch          = _var.value.branch
          comment_control = _var.value.comment_control
          invert_regex    = _var.value.invert_regex
        }
      }

      dynamic "push" {
        for_each = _conf.value.push != null ? [_conf.value.push] : []
        iterator = _var

        content {
          invert_regex = _var.value.invert_regex
          branch       = _var.value.branch
          tag          = _var.value.tag
        }
      }
    }
  }
}

resource "google_cloud_build_worker_pool" "main" {
  for_each = var.worker_pool != null ? { for v in var.worker_pool : v.name => v } : {}

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
