output "service_account" {
  value = !contains(local.none_apis, var.service) ? google_project_service_identity.main[var.service].email : local.none_apis[var.service]
}
