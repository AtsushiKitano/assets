locals {
  single_region_asc = var.single_zone ? [var.auto_scaling_policy] : []
  multi_region_asc  = ! var.single_zone ? [var.auto_scaling_policy] : []
}

resource "google_compute_autoscaler" "main" {
  provider = google-beta
  for_each = { for v in local.single_region_asc : v.name => v }

  name    = each.value.name
  target  = google_compute_instance_group_manager.main[var.group_manager.name].id
  zone    = var.zone
  project = var.project

  autoscaling_policy {
    min_replicas    = each.value.min_replicas
    max_replicas    = each.value.max_replicas
    cooldown_period = each.value.cooldown_period
    mode            = each.value.mode

    dynamic "cpu_utilization" {
      for_each = var.cpu_utilization != null ? [var.cpu_utilization] : []
      iterator = _conf

      content {
        target = _conf.value.target
      }
    }

    dynamic "scale_down_control" {
      for_each = var.scale_down_control != null ? [var.scale_down_control] : []
      iterator = _conf

      content {
        max_scaled_down_replicas {
          fixed   = _conf.value.max_scaled_down.percent == null ? _conf.value.max_scaled_down.fixed : null
          percent = _conf.value.max_scaled_down.fixed == null ? _conf.value.max_scaled_down.percent : null
        }
        time_window_sec = _conf.value.time_window_sec
      }
    }

    dynamic "scale_in_control" {
      for_each = var.scale_in_control != null ? [var.scale_in_control] : []
      iterator = _conf

      content {
        max_scaled_in_replicas {
          fixed   = _conf.value.max_scaled_down.percent == null ? _conf.value.max_scaled_down.fixed : null
          percent = _conf.value.max_scaled_down.fixed == null ? _conf.value.max_scaled_down.percent : null
        }
        time_window_sec = _conf.value.time_window_sec
      }
    }

    dynamic "metric" {
      for_each = var.metric != null ? [var.metric] : []
      iterator = _conf

      content {
        name                       = _conf.value.name
        single_instance_assignment = _conf.value.single_instance_assignment
        target                     = _conf.value.target
        type                       = _conf.value.type
        filter                     = _conf.value.filter
      }
    }

    dynamic "load_balancing_utilization" {
      for_each = var.load_balancing_utilization != null ? [var.load_balancing_utilization] : []
      iterator = _conf

      content {
        target = _conf.value.target
      }
    }
  }
}

resource "google_compute_region_autoscaler" "main" {
  provider = google-beta
  for_each = { for v in local.multi_region_asc : v.name => v }

  name    = each.value.name
  target  = google_compute_region_instance_group_manager.main[var.group_manager.name].id
  region  = var.region
  project = var.project

  autoscaling_policy {
    min_replicas    = each.value.min_replicas
    max_replicas    = each.value.max_replicas
    cooldown_period = each.value.cooldown_period
    mode            = each.value.mode

    dynamic "cpu_utilization" {
      for_each = var.cpu_utilization != null ? [var.cpu_utilization] : []
      iterator = _conf

      content {
        target = _conf.value.target
      }
    }

    dynamic "scale_down_control" {
      for_each = var.scale_down_control != null ? [var.scale_down_control] : []
      iterator = _conf

      content {
        max_scaled_down_replicas {
          fixed   = _conf.value.max_scaled_down.percent == null ? _conf.value.max_scaled_down.fixed : null
          percent = _conf.value.max_scaled_down.fixed == null ? _conf.value.max_scaled_down.percent : null
        }
        time_window_sec = _conf.value.time_window_sec
      }
    }

    dynamic "scale_in_control" {
      for_each = var.scale_in_control != null ? [var.scale_in_control] : []
      iterator = _conf

      content {
        max_scaled_in_replicas {
          fixed   = _conf.value.max_scaled_down.percent == null ? _conf.value.max_scaled_down.fixed : null
          percent = _conf.value.max_scaled_down.fixed == null ? _conf.value.max_scaled_down.percent : null
        }
        time_window_sec = _conf.value.time_window_sec
      }
    }

    dynamic "metric" {
      for_each = var.metric != null ? [var.metric] : []
      iterator = _conf

      content {
        name                       = _conf.value.name
        single_instance_assignment = _conf.value.single_instance_assignment
        target                     = _conf.value.target
        type                       = _conf.value.type
        filter                     = _conf.value.filter
      }
    }

    dynamic "load_balancing_utilization" {
      for_each = var.load_balancing_utilization != null ? [var.load_balancing_utilization] : []
      iterator = _conf

      content {
        target = _conf.value.target
      }
    }
  }
}
