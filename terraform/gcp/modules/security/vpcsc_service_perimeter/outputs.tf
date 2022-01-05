output "project_number" {
  value = var.status != null ? { for v in var.status.projects : v => data.google_project.main[v].number if contains(google_access_context_manager_service_perimeter.main.status.resources, format("projects/%d", data.google_project.main[v].number)) } : {}
}
