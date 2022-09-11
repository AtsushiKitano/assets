locals {
  service_agents = [
    "composer.googleapis.com"
  ]
}


resource "google_project_service" "apis" {
  for_each = toset(var.enabled_services)

  project                    = var.project
  service                    = each.value
  disable_dependent_services = var.disable_dependent_services
  disable_on_destroy         = var.disable_on_destroy
}

/*
Composer の APIを有効としたときにComposerのサービスエージェントに
roles/composer.ServiceAgentV2Extの権限を付与しVersion2を利用できるように
する
*/

resource "google_project_service_identity" "main" {
  provider = google-beta
  for_each = contains(var.enabled_services, "composer.googleapis.com") ? toset(local.service_agents) : []

  project = var.project
  service = each.value
}


resource "google_project_iam_member" "composer_v2_sa" {
  for_each = contains(var.enabled_services, "composer.googleapis.com") ? toset(["composer.googleapis.com"]) : []

  member  = format("serviceAccount:%s", google_project_service_identity.main[each.value].email)
  role    = "roles/composer.ServiceAgentV2Ext"
  project = var.project
}
