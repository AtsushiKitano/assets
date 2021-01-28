locals {
  _service_list = compact(distinct(flatten([
    for _conf in var.cron_job_conf : [
      for _sv in local.google_project_service_list : _sv
    ] if _conf.enable
  ])))

  google_project_service_list = [
    "appengine",
    "storage-component",
    "cloudbuild",
    "cloudscheduler",
    "cloudfunctions",
    "pubsub"
  ]
}

resource "google_project_service" "serviceusage" {

  service            = "serviceusage.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "main" {
  depends_on = [google_project_service.serviceusage]

  for_each           = toset(local.google_project_service_list)
  service            = join("", [each.value, ".googleapis.com"])
  disable_on_destroy = false
}
