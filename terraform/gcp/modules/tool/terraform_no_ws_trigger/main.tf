resource "google_cloudbuild_trigger" "plan" {
  name = "${var.repository}-${var.name}-pr-to-${var.default_branch}"

  github {
    owner = var.github_owner
    name  = var.repository
    pull_request {
      branch = "^${var.default_branch}$"
    }
  }

  ignored_files   = var.ignored_files
  included_files  = var.included_files
  filename        = var.plan_filename
  project         = var.project
  substitutions   = var.substitutions
  service_account = var.service_account
}

resource "google_cloudbuild_trigger" "apply" {
  name = "${var.repository}-${var.name}-push-to-${var.default_branch}"

  github {
    owner = var.github_owner
    name  = var.repository
    push {
      branch = "^${var.default_branch}$"
    }
  }

  ignored_files   = var.ignored_files
  included_files  = var.included_files
  filename        = var.apply_filename
  project         = var.project
  substitutions   = var.substitutions
  service_account = var.service_account
}
