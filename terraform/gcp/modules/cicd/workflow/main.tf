locals {
  _roles = concat(var.roles, ["roles/workflows.invoker"])
}

resource "google_service_account" "main" {
  account_id = format("wf-%s", var.name)
  project    = var.project
}

resource "google_project_iam_member" "main" {
  for_each = toset(local._roles)

  project = var.default_project
  role    = each.value
  member  = format("serviceAccount:%s", google_service_account.main.email)
}

resource "google_workflows_workflow" "main" {
  name            = var.name
  project         = var.project
  region          = var.region
  description     = var.description
  service_account = google_service_account.main.email
  source_contents = var.source_contents
}

resource "google_cloud_scheduler_job" "main" {
  for_each = var.enabled_schedulering ? toset([var.name]) : []

  name      = var.name
  schedule  = var.schedule
  time_zone = var.time_zone
  project   = google_workflows_workflow.main.project
  region    = var.region

  http_target {
    http_method = "POST"
    uri         = format("https://workflowexecutions.googleapis.com/v1/projects/%s/locations/global/workflows/%s/executions", google_workflows_workflow.main.project, google_workflows_workflow.main.name)
    body        = var.body != null ? base64encode(var.body) : null

    oauth_token {
      service_account_email = data.google_service_account.main.email
      scope                 = "https://www.googleapis.com/auth/cloud-platform"
    }
  }
}
