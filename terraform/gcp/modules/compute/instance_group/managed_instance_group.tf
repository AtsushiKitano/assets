locals {
  single_region_mng = var.single_zone ? [var.group_manager] : []
  multi_region_mng  = ! var.single_zone ? [var.group_manager] : []
}

resource "google_compute_region_instance_group_manager" "main" {
  for_each = { for v in local.multi_region_mng : v.name => v }

  base_instance_name = each.value.base_name
  name               = each.value.name
  region             = var.region
  project            = var.project
  target_pools       = each.value.target_pools
  target_size        = each.value.target_size
  wait_for_instances = var.wait_for_instances

  distribution_policy_zones = var.distribution_policy_zones

  version {
    name              = each.value.version.name
    instance_template = google_compute_instance_template.main.id

    dynamic "target_size" {
      for_each = each.value.version.target_size != null ? [each.value.target_size] : []
      iterator = _conf

      content {
        fixed   = _conf.value.percent == null ? _conf.value.fixed : null
        percent = _conf.value.fixed == null ? _conf.value.percent : null
      }
    }
  }


  dynamic "update_policy" {
    for_each = var.update_policy != null ? [var.update_policy] : []
    iterator = _conf

    content {
      minimal_action               = _conf.value.minimal_action
      type                         = _conf.value.type
      instance_redistribution_type = _conf.value.instance_redistribution_type
      max_surge_fixed              = _conf.value.max_surge_percent == null ? _conf.value.max_surge_fixed : null
      max_surge_percent            = _conf.value.max_surge_fixed == null ? _conf.value.max_surge_percent : null
      max_unavailable_fixed        = _conf.value.max_unavailable_percent == null ? _conf.value.max_unavailable_fixed : null
      max_unavailable_percent      = _conf.value.max_unavailable_fixed == null ? _conf.value.max_unavailable_percent : null
      min_ready_sec                = _conf.value.min_ready_sec
    }
  }

  dynamic "named_port" {
    for_each = var.named_port != null ? [var.named_port] : []
    iterator = _conf

    content {
      name = _conf.value.name
      port = _conf.value.port
    }
  }

  dynamic "auto_healing_policies" {
    for_each = var.auto_healing_policies != null ? [var.auto_healing_policies] : []
    iterator = _conf

    content {
      health_check      = _conf.value.health_check
      initial_delay_sec = _conf.value.initial_delay_sec
    }
  }

  dynamic "stateful_disk" {
    for_each = var.stateful_disk != null ? [var.stateful_disk] : []
    iterator = _conf

    content {
      device_name = _conf.value.device_name
      delete_rule = _conf.value.delete_rule
    }
  }

}

resource "google_compute_instance_group_manager" "main" {
  for_each = { for v in local.single_region_mng : v.name => v }

  base_instance_name = each.value.base_name
  name               = each.value.name
  zone               = var.zone
  project            = var.project
  target_pools       = each.value.target_pools
  target_size        = each.value.target_size
  wait_for_instances = var.wait_for_instances

  version {
    name              = each.value.version.name
    instance_template = google_compute_instance_template.main.id

    dynamic "target_size" {
      for_each = each.value.target_size != null ? [each.value.target_size] : []
      iterator = _conf

      content {
        fixed   = _conf.value.percent != null ? _conf.value.fixed : null
        percent = _conf.value.fixed != null ? _conf.value.percent : null
      }
    }
  }

  dynamic "update_policy" {
    for_each = var.update_policy != null ? [var.update_policy] : []
    iterator = _conf

    content {
      minimal_action          = _conf.value.minimal_action
      type                    = _conf.value.type
      max_surge_fixed         = _conf.value.max_surge_percent == null ? _conf.value.max_surge_fixed : null
      max_surge_percent       = _conf.value.max_surge_fixed == null ? _conf.value.max_surge_percent : null
      max_unavailable_fixed   = _conf.value.max_unavailable_percent == null ? _conf.value.max_unavailable_fixed : null
      max_unavailable_percent = _conf.value.max_unavailable_fixed == null ? _conf.value.max_unavailable_percent : null
      min_ready_sec           = _conf.value.min_ready_sec
    }
  }

  dynamic "named_port" {
    for_each = var.named_port != null ? [var.named_port] : []
    iterator = _conf

    content {
      name = _conf.value.name
      port = _conf.value.port
    }
  }

  dynamic "auto_healing_policies" {
    for_each = var.auto_healing_policies != null ? [var.auto_healing_policies] : []
    iterator = _conf

    content {
      health_check      = _conf.value.health_check
      initial_delay_sec = _conf.value.initial_delay_sec
    }
  }

  dynamic "stateful_disk" {
    for_each = var.stateful_disk != null ? [var.stateful_disk] : []
    iterator = _conf

    content {
      device_name = _conf.value.device_name
      delete_rule = _conf.value.delete_rule
    }
  }
}
