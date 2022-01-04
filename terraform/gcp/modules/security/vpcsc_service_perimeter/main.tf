locals {
  _parent = format("accessPolicies/%d", var.access_policy)
  _projects = length(var.status) > 0 ? distinct(flatten([
    for v in var.status : [
      for w in w.projects : w
    ]
  ])) : []
}

data "google_project" "main" {
  for_each = toset(local._projects)

  project_id = each.value
}

resource "google_access_context_manager_service_perimeter" "main" {
  parent = local._parent
  title  = var.title
  name   = var.name != null ? format("%s/servicePerimeters/%s", local._parent, var.name) : format("%s/servicePerimeters/%s", local._parent, var.title)

  description    = var.description
  perimeter_type = "PERIMETER_TYPE_REGULAR"

  dynamic "status" {
    for_each = var.status != null ? toset(["dummy"]) : []

    content {
      resources           = [for v in var.status.project : format("projects/%d", data.google_project.main[v].number)]
      restricted_services = var.status.restricted_services
      access_levels       = var.status.access_levels
    }
  }
}
