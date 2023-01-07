locals {
  api_list = concat(
    var.use_gke ? [local.service_api_domains_list.gke] : [],
  )

  service_api_domains_list = {
    "gke" = "container.googleapis.com"
  }

  service_accounts = merge(
    {
      service_project = format("%s@cloudservices.gserviceaccount.com", data.google_project.main.number),
    },
    var.use_gke ? {
      gke = google_project_service_identity.main[local.service_api_domains_list.gke].email
    } : null
  )

  subnetwork_iam_policies = flatten([
    for v in var.service_subnetworks : [
      for w in keys(local.service_accounts) : {
        region          = v.region
        name            = v.name
        service_account = w
      }
    ]
  ])

  gke_roles = [
    "roles/compute.securityAdmin",
    "roles/container.hostServiceAgentUser"
  ]
}


resource "google_project_service_identity" "main" {
  for_each = toset(local.api_list)
  provider = google-beta

  project = var.service_project
  service = each.value
}

data "google_compute_network" "main" {
  name    = var.shared_vpc_network
  project = var.host_project
}

data "google_project" "main" {
  project_id = var.service_project
}

resource "google_compute_shared_vpc_service_project" "main" {
  host_project    = var.host_project
  service_project = var.service_project
}

resource "google_compute_subnetwork" "main" {
  for_each = { for v in var.service_subnetworks : format("%s/%s", v.region, v.name) => v }

  name                     = each.value.name
  ip_cidr_range            = each.value.ip_cidr_range
  region                   = each.value.region
  project                  = var.host_project
  network                  = data.google_compute_network.main.self_link
  private_ip_google_access = each.value.private_ip_google_access

  dynamic "secondary_ip_range" {
    for_each = each.value.secondary_ip_range
    iterator = config

    content {
      range_name    = config.value.range_name
      ip_cidr_range = config.value.ip_cidr_range
    }
  }

  dynamic "log_config" {
    for_each = each.value.log_enabled ? [each.value.log_config] : []
    iterator = config

    content {
      aggregation_interval = config.value.aggregation_interval
      flow_sampling        = config.value.flow_sampling
      metadata             = config.value.metadata
    }
  }

  lifecycle {
    ignore_changes = [
      network
    ]
  }
}

resource "google_compute_subnetwork_iam_member" "main" {
  for_each = { for v in local.subnetwork_iam_policies : format("%s/%s/%s", v.region, v.name, v.service_account) => v }

  project    = var.host_project
  role       = "roles/compute.networkUser"
  region     = google_compute_subnetwork.main[format("%s/%s", each.value.region, each.value.name)].region
  subnetwork = google_compute_subnetwork.main[format("%s/%s", each.value.region, each.value.name)].name
  member     = format("serviceAccount:%s", local.service_accounts[each.value.service_account])

  lifecycle {
    ignore_changes = [
      member
    ]
  }
}

resource "google_project_iam_member" "gke" {
  for_each = var.use_gke ? toset(local.gke_roles) : []

  project = var.host_project
  role    = each.value
  member  = format("serviceAccount:%s", local.service_accounts.gke)
}
