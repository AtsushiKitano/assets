output "email" {
  value = { for v in local._services : v => google_project_service_identity.main[v].email }
}
