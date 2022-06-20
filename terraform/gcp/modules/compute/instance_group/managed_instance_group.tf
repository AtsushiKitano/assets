locals {
  single_region_mng = !var.multi_region_enabled ? [var.name] : []
  multi_region_mng  = var.multi_region_enabled ? [var.name] : []
}

resource "google_compute_region_instance_group_manager" "main" {
  for_each = toset(local.multi_region_mng)

  base_instance_name = var.base_instance_name
  name               = var.name
  region             = var.region
  project            = var.project
  target_pools       = var.target_pools
  target_size        = var.target_size
  wait_for_instances = var.wait_for_instances

  version {
    name              = var.version_name
    instance_template = google_compute_instance_template.main.id

    dynamic "target_size" {
      for_each = var.target_size_enabled ? ["dummy"] : []

      content {
        fixed   = var.fixed_size
        percent = var.percent
      }
    }
  }

  dynamic "auto_healing_policies" {
    for_each = var.auto_healing_elebled ? ["dummy"] : []

    content {
      health_check      = google_compute_health_check.main.id
      initial_delay_sec = var.initial_delay_sec
    }
  }

  dynamic "update_policy" {
    for_each = var.update_policy_enabled || var.stateful_disk_enabled ? ["dummy"] : []

    content {
      minimal_action               = var.minimal_action
      type                         = var.update_policy_type
      instance_redistribution_type = var.instance_redistribution_type
      max_unavailable_fixed        = var.max_unavailable_fixed
    }
  }

  dynamic "stateful_disk" {
    for_each = var.stateful_disk_enabled ? ["dummy"] : []

    content {
      device_name = var.device_name
      delete_rule = var.delete_rule
    }
  }

}

resource "google_compute_instance_group_manager" "main" {
  for_each = toset(local.single_region_mng)

  base_instance_name = var.base_instance_name
  name               = var.name
  zone               = var.zone
  project            = var.project
  target_pools       = var.target_pools
  target_size        = var.target_size
  wait_for_instances = var.wait_for_instances

  version {
    name              = var.version_name
    instance_template = google_compute_instance_template.main.id

    dynamic "target_size" {
      for_each = var.target_size_enabled ? ["dummy"] : []

      content {
        fixed   = var.fixed_size
        percent = var.percent
      }
    }
  }

  dynamic "update_policy" {
    for_each = var.update_policy_enabled || var.stateful_disk_enabled ? ["dummy"] : []

    content {
      minimal_action        = var.minimal_action
      type                  = var.update_policy_type
      max_unavailable_fixed = var.max_unavailable_fixed
    }
  }

  dynamic "auto_healing_policies" {
    for_each = var.auto_healing_elebled ? ["dummy"] : []

    content {
      health_check      = google_compute_health_check.main.id
      initial_delay_sec = var.initial_delay_sec
    }
  }

  dynamic "stateful_disk" {
    for_each = var.stateful_disk_enabled ? ["dummy"] : []

    content {
      device_name = var.device_name
      delete_rule = var.delete_rule
    }
  }
}

resource "google_compute_health_check" "main" {
  name    = var.name
  project = var.project

  timeout_sec        = var.timeout_sec
  check_interval_sec = var.check_interval_sec
  tcp_health_check {
    port = var.port
  }
}
