locals {
  none_apis = {
    gce            = format("service-%s@compute-system.iam.gserviceaccount.com", data.google_project.main.number)
    gke            = format("service-%s@container-engine-robot.iam.gserviceaccount.com", data.google_project.main.number)
    gke_node       = format("service-%s@gcp-sa-gkenode.iam.gserviceaccount.com", data.google_project.main.number)
    gcs            = format("service-%s@gs-project-accounts.iam.gserviceaccount.com", data.google_project.main.number)
    cloud_run      = format("service-%s@serverless-robot-prod.iam.gserviceaccount.com", data.google_project.main.number)
    cloud_function = format("service-%s@gcf-admin-robot.iam.gserviceaccount.com", data.google_project.main.number)
    cloud_sql      = format("service-%s@gcp-sa-cloud-sql.iam.gserviceaccount.com", data.google_project.main.number)
    cloud_composer = format("service-%s@cloudcomposer-accounts.iam.gserviceaccount.com", data.google_project.main.number)
    big_table      = format("service-%s@gcp-sa-bigtable.iam.gserviceaccount.com", data.google_project.main.number)
    bq             = format("bq-%s@bigquery-encryption.iam.gserviceaccount.com", data.google_project.main.number)
    service_agent  = format("%s@cloudservices.gserviceaccount.com", data.google_project.main.number)
  }
}

resource "google_project_service_identity" "main" {
  for_each = !contains(local.none_apis, var.service) ? toset([var.service]) : []
  provider = google-beta

  project = var.project
  service = format("%s.googleapis.com", each.value)
}

data "google_project" "main" {
  project_id = var.project
}
