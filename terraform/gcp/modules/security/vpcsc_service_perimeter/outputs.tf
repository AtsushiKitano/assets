output "project_number" {
  value = var.status != null ? { for v in var.status.projects : v => data.google_project.main[v].number } : {}
}
