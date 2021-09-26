resource "google_cloudbuild_trigger" "plan" {
  provider = google-beta

  name = "${var.repository}-pr-to-${var.default_branch}"

  github {
    owner = var.github_owner
    name  = var.repository
    pull_request {
      branch = "^${var.default_branch}$"
    }
  }

  ignored_files = var.ignored_files
  filename      = var.plan_file_name
  project       = var.project
  substitutions = var.substitutions
}

resource "google_cloudbuild_trigger" "apply" {
  provider = google-beta

  name = "${var.repository}-push-to-${var.default_branch}"

  github {
    owner = var.github_owner
    name  = var.repository
    pull_request {
      branch = "^${var.default_branch}$"
    }
  }

  ignored_files = var.ignored_files
  filename      = var.apply_file_name
  project       = var.project
  substitutions = var.substitutions
}
