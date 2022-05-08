output "projects" {
  value = { for v in var.projects : v => format("projects/%s", data.google_project.main[v].number) }
}
