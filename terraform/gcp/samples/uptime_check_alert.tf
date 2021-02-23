locals {
  uptime_check_alert_enabled = false

  _uptime_check_alert_conf = local.uptime_check_alert_enabled ? [
    {
      name = "sample"
    }
  ] : []
}

module "uptime_check_alert_sample" {
  for_each = { for v in local._uptime_check_alert_conf : v.name => v }
  source   = "../modules/operation/alert/uptime_check"

  conf = {
    display_name = each.value.name
    timeout      = "60s"
    period       = "60s"
    combiner     = "OR"
  }

  http_check = {
    path           = "/"
    port           = "8080"
    request_method = "GET"
    headers        = {}
    use_ssl        = false
    mask_headers   = false
    validate_ssl   = null
    body           = null
    content_type   = null
  }

  monitored_resource = {
    type = "gce_instance"
    labels = {
      host        = module.uptime_check_alert_sample_gce[each.value.name].network_ip
      project_id  = terraform.workspace
      instance_id = module.uptime_check_alert_sample_gce[each.value.name].instance_id
      zone        = "asia-northeast1-b"
    }
  }

  conditions = [
    {
      name         = null
      display_name = each.value.name
      duration     = "60s"
      trigger = {
        type  = "count"
        value = 1
      }

      aggregations = {
        per_series_aligner   = "ALIGN_NEXT_OLDER"
        group_by_fields      = ["resouce.label.*"]
        cross_series_reducer = "REDUCE_COUNT_FALSE"
        alignment_period     = "1200s"
      }

      condition_threshold = {
        comparison      = "COMPARISON_GT"
        threshold_value = "1"
      }
    }
  ]
}

module "uptime_check_alert_sample_gce" {
  for_each = { for v in local._uptime_check_alert_conf : v.name => v }
  source   = "../modules/compute/gce"

  gce_instance = {
    name         = "sample"
    machine_type = "f1-micro"
    zone         = "asia-northeast1-b"
    subnetwork   = module.uptime_check_alert_sample_nw[each.value.name].subnetwork_self_link["sample-gce-nw"]
    tags         = []
  }

  boot_disk = {
    name      = "sample"
    size      = 20
    interface = null
    image     = "ubuntu-os-cloud/ubuntu-2004-lts"
  }

  service_account = module.uptime_check_alert_sample_sa[each.value.name].email
}

module "uptime_check_alert_sample_nw" {
  for_each = { for v in local._uptime_check_alert_conf : v.name => v }
  source   = "../modules/network/vpc_network"

  project = terraform.workspace

  vpc_network = {
    name = "sample-gce-nw"
  }
  subnetworks = [
    {
      name   = "sample-gce-nw"
      cidr   = "192.168.10.0/24"
      region = "asia-northeast1"
    },
  ]

  firewall = [
    {
      direction = "INGRESS"
      name      = "ingress-sample-gce"
      tags      = []
      ranges    = ["0.0.0.0/0"]
      priority  = 1000
      rules = [
        {
          type     = "allow"
          protocol = "tcp"
          ports    = ["22"]
        }
      ]
      log_config_metadata = null
    },
  ]
}

module "uptime_check_alert_sample_sa" {
  for_each = { for v in local._uptime_check_alert_conf : v.name => v }
  source   = "../modules/iam/service_account"

  service_account = {
    name = "sample"
    roles = [
      "editor"
    ]
  }
}
