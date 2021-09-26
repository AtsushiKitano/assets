resource "google_cloudbuild_trigger" "plan" {
  provider = google-beta

  name = "${var.repository}-${var.name}-pr-to-${var.default_branch}"

  github {
    owner = var.github_owner
    name  = var.repository
    pull_request {
      branch = "^${var.default_branch}$"
    }
  }

  ignored_files  = var.ignored_files
  included_files = var.included_files
  filename       = var.plan_filename
  project        = var.project
  substitutions  = var.substitutions
}

resource "google_cloudbuild_trigger" "apply" {
  provider = google-beta

  name = "${var.repository}-${var.name}-push-to-${var.default_branch}"

  github {
    owner = var.github_owner
    name  = var.repository
    push {
      branch = "^${var.default_branch}$"
    }
  }

  ignored_files  = var.ignored_files
  included_files = var.included_files
  filename       = var.apply_filename
  project        = var.project
  substitutions  = var.substitutions
}
