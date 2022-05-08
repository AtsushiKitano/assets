locals {
  members = concat(
    [for v in var.users : format("user:%s", v)],
    [for v in var.service_accounts : format("serviceAccount:%s", v)],
  )

  additional_members = concat(
    flatten([for v in var.additional_conditions : [for w in v.users : format("user:%s", w)]]),
    flatten([for v in var.additional_conditions : [for w in v.service_accounts : format("serviceAccount:%s", w)]]),
  )
}

resource "google_access_context_manager_access_level" "main" {
  parent = format("accessPolicies/%s", var.parent)
  name   = format("accessPolicies/%s/accessLevels/%s", var.parent, var.title)
  title  = var.title

  basic {
    combining_function = var.combining_function

    conditions {
      ip_subnetworks = var.ip_addresses
      members        = local.members
      regions        = var.regions
    }
  }
}

resource "google_access_context_manager_access_level_condition" "main" {
  count        = length(var.additional_conditions)
  access_level = google_access_context_manager_access_level.main.name

  ip_subnetworks = var.additional_conditions[count.index].ip_addresses
  members        = local.additional_members
  regions        = var.additional_conditions[count.index].regions
}
