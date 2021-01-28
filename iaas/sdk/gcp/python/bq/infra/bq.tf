locals {
  job_query = {
    enable = false

    dataset_id = "github_source_data"
    table_id   = "git_sample"
    location   = "US"
  }

  fluentd_log = {
    enable = false
    zone   = "us-central1-c"
    region = "us-central1"

    gce = {
      name         = "fluentd-log"
      machine_type = "n1-standard-1"
      disk_size    = 30
      disk_type    = "pd-ssd"
      disk_image   = "bq-fluentd"
    }

    network = {
      name        = "fluentd-log"
      cidr        = "192.168.0.0/24"
      description = "analyze fluentd log"
    }

    bq = {
      location   = "US"
      dataset_id = "fluentd"
      table_id   = "nginx_access"
    }
  }
}

module "job_query" {
  source = "../../../../../../terraform/gcp/modules/bq"

  bq_conf = [
    {
      enable = local.job_query.enable

      dataset_conf = {
        dataset_id = local.job_query.dataset_id
        location   = local.job_query.location
        opt_conf   = {}
      }

      table_conf = [
        {
          enable = true

          table_id = local.job_query.table_id
          opt_conf = {}
        }
      ]

      query_job_conf = [
      ]
    }
  ]
}

module "fluentd_log_gce" {
  depends_on = [
    module.fluentd_nw,
    module.fluentd_bq,
    module.fluentd_sa
  ]
  source = "../../../../../../terraform/gcp/modules/gce"

  gce_conf = [
    {
      gce_enable = local.fluentd_log.enable

      name         = local.fluentd_log.gce.name
      machine_type = local.fluentd_log.gce.machine_type
      zone         = local.fluentd_log.zone
      region       = local.fluentd_log.region
      tags         = ["fluentd-log"]
      subnetwork   = local.fluentd_log.network.name
      opt_conf = {
        metadata_startup_script = "td_config"
        preemptible             = true
      }
      service_account = {
        email  = local.fluentd_log.gce.name
        scopes = [
          "cloud-platform"
        ]
      }
      boot_disk = {
        size     = local.fluentd_log.gce.disk_size
        type     = local.fluentd_log.gce.disk_type
        image    = local.fluentd_log.gce.disk_image
        opt_conf = {}
      }
    }
  ]

}

module "fluentd_nw" {
  source = "../../../../../../terraform/gcp/modules/network"

  network_conf = [
    {
      vpc_network_enable      = local.fluentd_log.enable
      subnetwork_enable       = true
      firewall_ingress_enable = true
      firewall_egress_enable  = true
      route_enable            = true

      vpc_network_conf = {
        name     = local.fluentd_log.network.name
        opt_conf = {}
      }

      subnetwork = [
        {
          name        = local.fluentd_log.network.name
          cidr        = local.fluentd_log.network.cidr
          description = local.fluentd_log.network.description
          region      = local.fluentd_log.region
          opt_conf    = {}
        }
      ]

      firewall_ingress_conf = [
        {
          name          = "ssh-enable"
          priority      = 1000
          source_ranges = ["0.0.0.0/0"]
          target_tags   = []
          allow_rules = [
            {
              protocol = "tcp"
              ports    = ["22", "80", "443"]
            }
          ]
          deny_rules = []
          opt_conf   = {}
        }
      ]

      firewall_egress_conf = [
      ]
      route_conf = [
      ]
    },
  ]
}

module "fluentd_bq" {
  source = "../../../../../../terraform/gcp/modules/bq"

  bq_conf = [
    {
      enable = local.fluentd_log.enable

      dataset_conf = {
        dataset_id = local.fluentd_log.bq.dataset_id
        location   = local.fluentd_log.bq.location
        opt_conf   = {}
      }

      table_conf = [
        {
          enable = true

          table_id = local.fluentd_log.bq.table_id
          opt_conf = {
            schema            = file("./fluentd_table_schem.json")
            time_partitioning = false
          }
        }
      ]

      query_job_conf = [
      ]
    }
  ]
}

module "fluentd_sa" {
  source = "../../../../../../terraform/gcp/modules/service_account"

  service_account_conf = [{
    enable = local.fluentd_log.enable

    account_id = local.fluentd_log.gce.name
  }]
}

module "fluentd_iam" {
  depends_on = [
    module.fluentd_sa
  ]
  source = "../../../../../../terraform/gcp/modules/iam"

  iam_member_conf = [{
    enable = local.fluentd_log.enable

    member = local.fluentd_log.gce.name
    member_type = "serviceAccount"
    role = [
      "roles/bigquery.admin"
    ]
  }]
}
