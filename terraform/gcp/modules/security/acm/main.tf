locals {
  members = concat(
    flatten([for v in var.conditions : [for w in v.users : format("user:%s", w)]]),
    flatten([for v in var.conditions : [for w in v.service_accounts : format("serviceAccount:%s", w)]])
  )
}

resource "google_access_context_manager_access_level" "main" {
  parent = format("accessPolicies/%s", var.parent)
  name   = format("accessPolicies/%s/accessLevels/%s", var.parent, var.title)
  title  = var.title
}

resource "google_access_context_manager_access_level_condition" "main" {
  count        = length(var.conditions)
  access_level = google_access_context_manager_access_level.main.name

  ip_subnetworks = var.conditions[count.index].ip_addresses
  members        = local.members
  regions        = var.conditions[count.index].regions
}
