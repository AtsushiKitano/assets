locals {
  triggers = [
    {
      name = format("%s-terraform-apply", var.name)
      file = var.terraform_apply_file
    },
    {
      name = format("%s-terraform-plan", var.name)
      file = var.terraform_plan_file
    },
    {
      name = format("%s-terraform-destroy", var.name)
      file = var.terraform_destroy_file
    },
  ]
}

resource "google_cloudbuild_trigger" "main" {
  for_each = { for v in local.triggers : v.name => v if !(var.disabled_plan_task && reverse(split(v.name))[0] == "plan") }

  name            = each.value.name
  project         = var.project
  service_account = data.google_service_account.main.id

  source_to_build {
    uri       = format("https://github.com/%s/%s", var.repo.owner, var.repo.name)
    ref       = var.ref
    repo_type = var.repo_type
  }

  git_file_source {
    path      = format("%s/%s", var.cloud_build_dir_path, each.value.file)
    uri       = format("https://github.com/%s/%s", var.repo.owner, var.repo.name)
    revision  = var.ref
    repo_type = var.repo_type
  }

  substitutions = var.substitutions
}

data "google_service_account" "main" {
  account_id = var.service_account
  project    = var.project
}

resource "google_cloud_scheduler_job" "main" {
  for_each = var.enabled_delete_scheduler_job ? toset([format("%s-terraform-destroy", var.name)]) : []

  name      = format("%s-daily-job", each.value)
  schedule  = var.schedule
  time_zone = var.time_zone
  project   = google_cloudbuild_trigger.main[each.value].project
  region    = var.region

  http_target {
    http_method = "POST"
    uri         = format("https://cloudbuild.googleapis.com/v1/projects/%s/locations/global/triggers/%s:run", google_cloudbuild_trigger.main[each.value].project, google_cloudbuild_trigger.main[each.value].trigger_id)
    body        = var.body

    oauth_token {
      service_account_email = data.google_service_account.main.email
      scope                 = "https://www.googleapis.com/auth/cloud-platform"
    }
  }
}
