resource "google_compute_autoscaler" "main" {
  for_each = var.autoscale_enabled && !var.stateful_disk_enabled ? toset(local.single_region_mng) : []

  name    = var.name
  target  = google_compute_instance_group_manager.main[var.name].id
  zone    = var.zone
  project = var.project

  autoscaling_policy {
    min_replicas    = var.min_replicas
    max_replicas    = var.max_replicas
    cooldown_period = var.cooldown_period
    mode            = var.mode

    dynamic "cpu_utilization" {
      for_each = var.cpu_utilization_target != null ? ["dummy"] : []

      content {
        target            = var.cpu_utilization_target
        predictive_method = var.predictive_method
      }
    }
  }
}

resource "google_compute_region_autoscaler" "main" {
  for_each = var.autoscale_enabled && !var.stateful_disk_enabled ? toset(local.multi_region_mng) : []

  name    = var.name
  target  = google_compute_region_instance_group_manager.main[var.name].id
  region  = var.region
  project = var.project

  autoscaling_policy {
    min_replicas    = var.min_replicas
    max_replicas    = var.max_replicas
    cooldown_period = var.cooldown_period
    mode            = var.mode

    dynamic "cpu_utilization" {
      for_each = var.cpu_utilization_target != null ? ["dummy"] : []

      content {
        target = var.cpu_utilization_target
      }
    }
  }
}
