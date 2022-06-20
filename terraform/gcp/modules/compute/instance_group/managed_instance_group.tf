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

  distribution_policy_zones = var.distribution_policy_zones

  version {
    name              = each.version_name
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
      health_check = length(local.multi_region_mng) > 0 ? google_compute_region_health_check.main[var.name].id : null
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
  for_each = { for v in local.single_region_mng : v.name => v }

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

  dynamic "auto_healing_policies" {
    for_each = var.auto_healing_elebled ? ["dummy"] : []

    content {
      health_check = length(local.single_region_mng) > 0 ? google_compute_health_check.main[var.name].id : null
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

resource "google_compute_region_health_check" "main" {
  for_each = toset(local.multi_region_mng)

  name = var.name

  timeout_sec        = var.timeout_sec
  check_interval_sec = var.check_interval_sec
  tcp_health_check {
    port = var.port
  }
}

resource "google_compute_health_check" "main" {
  for_each = toset(local.single_region_mng)

  name = var.name

  timeout_sec        = var.timeout_sec
  check_interval_sec = var.check_interval_sec
  tcp_health_check {
    port = var.port
  }
}
