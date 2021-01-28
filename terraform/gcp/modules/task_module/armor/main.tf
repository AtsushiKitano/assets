locals {
  ips_map = var.files_rule.file_type == "json" ? jsondecode(file(var.files_rule.file_path)) : var.files_rule.file_type == "yaml" ? yamldecode(file(var.files_rule.file_path)) : csvdecode(file(var.files_rule.file_path))

  _ips_list = chunklist(flatten([
    for v in local.ips_map : v[var.files_rule.ip_prefix]
  ]), 10)

  _req_list = flatten([
    for _ele in local._ips_list : {
      ips            = _ele
      action         = var.files_rule.action
      priority       = var.files_rule.priority_base + index(local._ips_list, _ele)
      versioned_expr = var.files_rule.versioned_expr
    }
  ])

  _req = flatten([
    for _conf in var.armor_conf : {
      name  = _conf.name
      rules = local._req_list
      default_rule = {
        action         = _conf.default_rule.action
        priority       = _conf.default_rule.priority
        versioned_expr = _conf.default_rule.versioned_expr
        src_ip_ranges  = _conf.default_rule.src_ip_ranges
      }
    } if _conf.armor_enable
  ])
}

resource "google_compute_security_policy" "main" {
  for_each = { for v in local._req : v.name => v }

  name = each.value.name
  dynamic "rule" {
    for_each = each.value.rules
    content {
      action   = rule.value.action
      priority = rule.value.priority
      match {
        versioned_expr = rule.value.versioned_expr
        config {
          src_ip_ranges = rule.value.ips
        }
      }
    }
  }

  rule {
    action   = each.value.default_rule.action
    priority = each.value.default_rule.priority
    match {
      versioned_expr = each.value.default_rule.versioned_expr
      config {
        src_ip_ranges = each.value.default_rule.src_ip_ranges
      }
    }
  }
}
