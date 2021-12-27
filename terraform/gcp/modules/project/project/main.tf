resource "google_project" "main" {
  name            = var.project.name
  project_id      = var.project.id
  folder_id       = var.project.folder_id
  billing_account = var.project.billing_account

  skip_delete         = var.skip_delete
  auto_create_network = var.auto_create_network
}

resource "google_project_service" "main" {
  for_each = toset(var.enable_service_apis)

  project                    = google_project.main.project_id
  service                    = each.value
  disable_dependent_services = var.disable_dependent_services
  disable_on_destroy         = var.disable_on_destroy
}
