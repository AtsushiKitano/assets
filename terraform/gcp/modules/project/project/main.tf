resource "google_project" "main" {
  name            = var.project_name
  project_id      = var.project_id
  folder_id       = var.folder_id
  billing_account = var.billing_account

  skip_delete         = var.skip_delete
  auto_create_network = var.auto_create_network
}

resource "google_project_service" "main" {
  for_each = toset(var.service_apis)

  project                    = each.value.project
  service                    = each.value.service
  disable_dependent_services = var.disable_dependent_services
  disable_on_destroy         = var.disable_on_destroy
}
