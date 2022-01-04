locals {
  _parent = format("accessPolicies/%d", var.parent)

  _ip_addresses = flatten([
    for v in var.conditions : v.type == "IPAddress" ? v.conditions : []
  ])

  _members = flatten([
    for v in var.conditions : v.type == "GoogleAccount" ? v.conditions : []
  ])
}

resource "google_access_context_manager_access_level" "main" {
  parent = local._parent
  name   = var.name != null ? format("%s/accessLevels/%s", local._parent, var.name) : format("%s/accessLevels/%s", local._parent, var.title)
  title  = var.title

  basic {
    combining_function = var.combining_function

    dynamic "conditions" {
      for_each = local._ip_addresses
      iterator = _config

      content {
        ip_subnetworks = _config.value
      }
    }

    dynamic "conditions" {
      for_each = local._members
      iterator = _config

      content {
        members = _config.value
      }
    }
  }
}
