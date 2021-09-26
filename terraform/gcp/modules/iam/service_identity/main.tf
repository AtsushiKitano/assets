resource "google_project_service_identity" "main" {
  for_each = var.service != "bigquery.googleapis.com" && var.service != "storage.googleapis.com" && var.service != "compute.googleapis.com" ? toset(["enable"]) : []
  provider = google-beta

  project = var.project_id
  service = var.service
}

data "google_bigquery_default_service_account" "main" {
  for_each = var.service == "bigquery.googleapis.com" ? toset(["enable"]) : []
  project  = var.project_id
}

data "google_storage_project_service_account" "main" {
  for_each = var.service == "storage.googleapis.com" ? toset(["enable"]) : []
  project  = var.project_id
}

data "google_project" "main" {
  for_each   = var.service == "compute.googleapis.com" ? toset(["enable"]) : []
  project_id = var.project_id
}
