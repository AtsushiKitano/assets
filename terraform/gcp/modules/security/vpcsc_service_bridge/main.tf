locals {
  _parent = format("accessPolicies/%s", var.access_policy)
}

resource "google_access_context_manager_service_perimeter" "main" {
  parent = local._parent
  title  = var.title
  name   = var.name != null ? format("%s/servicePerimeters/%s", local._parent, var.name) : format("%s/servicePerimeters/%s", local._parent, var.title)

  description    = var.description
  perimeter_type = "PERIMETER_TYPE_BRIDGE"

  status {
    resources = [
      for v in var.projects : format("projects/%d", v)
    ]
  }
}
