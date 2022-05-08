resource "google_access_context_manager_service_perimeter" "main" {
  parent = format("accessPolicies/%s", var.parent)
  name   = format("accessPolicies/%s/servicePerimeters/%s", var.parent, var.title)
  title  = var.title

  perimeter_type = "PERIMETER_TYPE_BRIDGE"
}

resource "google_access_context_manager_service_perimeter_resource" "main" {
  for_each = toset(var.projects)

  perimeter_name = google_access_context_manager_service_perimeter.main.name
  resource       = var.projects
}
