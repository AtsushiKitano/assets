locals {
  _service = "${var.service}.googleapis.com"
}

resource "google_project_service_identity" "main" {
  for_each = local._service != "bigquery.googleapis.com" && local._service != "storage.googleapis.com" && local._service != "compute.googleapis.com" ? toset(["enable"]) : []
  provider = google-beta

  project = var.project_id
  service = local._service
}

data "google_bigquery_default_service_account" "main" {
  for_each = local._service == "bigquery.googleapis.com" ? toset(["enable"]) : []
  project  = var.project_id
}

data "google_storage_project_service_account" "main" {
  for_each = local._service == "storage.googleapis.com" ? toset(["enable"]) : []
  project  = var.project_id
}

data "google_project" "main" {
  for_each   = local._service == "compute.googleapis.com" ? toset(["enable"]) : []
  project_id = var.project_id
}
