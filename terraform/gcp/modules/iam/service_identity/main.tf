locals {
  _exclude_services = [
    "bigquery.googleapis.com",
    "storage.googleapis.com",
    "compute.googleapis.com"
  ]

  _services = [
    for v in var.services : v if !contains(local._exclude_services, v)
  ]

  _service_emails_wo_exclude_services = {
    for v in local._services : v => google_project_service_identity.main[v].email
  }

  _service_emails_all = merge(
    local._service_emails_wo_exclude_services,
    { for v in ["bigquery.googleapis.com"] : v => contains(var.services, v) ? data.google_bigquery_default_service_account.main["enable"].email : "" },
    { for v in ["storage.googleapis.com"] : v => contains(var.services, v) ? data.google_storage_project_service_account.main["enable"].email_address : "" },
    { for v in ["compute.googleapis.com"] : v => contains(var.services, v) ? "service-${data.google_project.main["enable"].number}@compute-system.iam.gserviceaccount.com" : "" },
  )

  kms_keyring_assign_services = flatten([
    for v in var.kms_key_ring_iam_roles : [
      for w in var.services : {
        service     = w
        key_ring_id = v.key_ring_id
        role        = v.role
      }
    ]
  ])

  kms_crypto_key_assign_services = flatten([
    for v in var.kms_crypto_key_iam_roles : [
      for w in var.services : {
        service       = w
        crypto_key_id = v.crypto_key_id
        role          = v.role
      }
    ]
  ])

  artifact_registry_repository_assign_services = flatten([
    for role in var.artifact_registry_repository_iam_roles : [
      for service in var.services : {
        service    = service
        project    = role.project
        location   = role.location
        repository = role.repository
        role       = role.role
      }
    ]
  ])
}

resource "google_project_service_identity" "main" {
  for_each = toset(local._services)
  provider = google-beta

  project = var.project_id
  service = each.value
}

data "google_bigquery_default_service_account" "main" {
  for_each = contains(var.services, "bigquery.googleapis.com") ? toset(["enable"]) : []
  project  = var.project_id
}

data "google_storage_project_service_account" "main" {
  for_each = contains(var.services, "storage.googleapis.com") ? toset(["enable"]) : []
  project  = var.project_id
}

data "google_project" "main" {
  for_each   = contains(var.services, "compute.googleapis.com") ? toset(["enable"]) : []
  project_id = var.project_id
}


resource "google_kms_key_ring_iam_member" "main" {
  for_each = { for policy in local.kms_keyring_assign_services : format("%s/%s/%s", policy["service"], policy["key_ring_id"], policy["role"]) => policy }

  member      = "serviceAccount:${local._service_emails_all[each.value["service"]]}"
  key_ring_id = each.value.key_ring_id
  role        = each.value.role
}

resource "google_kms_crypto_key_iam_member" "crypto_key" {
  for_each = { for policy in local.kms_crypto_key_assign_services : format("%s/%s/%s", policy["service"], policy["crypto_key_id"], policy["role"]) => policy }

  member        = "serviceAccount:${local._service_emails_all[each.value["service"]]}"
  crypto_key_id = each.value.crypto_key_id
  role          = each.value.role
}

resource "google_artifact_registry_repository_iam_member" "main" {
  for_each = { for policy in local.artifact_registry_repository_assign_services : format("%s/%s/%s/%s", policy["service"], policy["project"], policy["repository"], policy["role"]) => policy }
  provider = google-beta

  project    = each.value.project
  location   = each.value.location
  repository = each.value.repository
  role       = each.value.role
  member     = "serviceAccount:${local._service_emails_all[each.value["service"]]}"
}
