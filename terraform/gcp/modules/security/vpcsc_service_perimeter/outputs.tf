output "project_number" {
  value = { for v in local._projects : v => data.google_project.main[v].number }
}
