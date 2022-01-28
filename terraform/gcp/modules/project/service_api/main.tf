resource "google_project_service" "main" {
  for_each = toset(var.services)

  project = var.project
  service = each.value

  dynamic "timeouts" {
    for_each = var.timeouts != null ? ["dummy"] : []

    content {
      create = var.timeouts.create
      update = var.timeouts.update
    }
  }

  disable_dependent_services = var.disable_dependent_services
  disable_on_destroy         = var.disable_on_destroy
}