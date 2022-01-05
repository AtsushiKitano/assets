output "project_number" {
  value = var.status != null && length(var.status.projects) > 0 ? { for v in var.status.projects : v => data.google_project.main[v].number if contains(google_access_context_manager_service_perimeter.main.status[0].resources, format("projects/%d", data.google_project.main[v].number)) } : {}
}
