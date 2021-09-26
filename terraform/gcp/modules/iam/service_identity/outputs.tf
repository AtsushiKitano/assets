output "email" {
  value = local._service == "bigquery.googleapis.com" ? data.google_bigquery_default_service_account.main["enable"].email : local._service == "storage.googleapis.com" ? google_storage_project_service_account.main["enable"].email : local._service == "compute.googleapis.com" ? "service-${data.google_project.main["enable"].number}@compute-system.iam.gserviceaccount.com" : google_project_service_identity.main["enable"].email
}
