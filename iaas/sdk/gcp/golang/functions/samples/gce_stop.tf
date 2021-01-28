locals {
  region = "asia-northeast1"
  enable = true
}

module "stop_gce" {
  source = "../../../../../../terraform/gcp/modules/glue"

  glue_conf = [
    {
      enable = local.enable

      gcf_conf = {
        name    = "stop-all-gce"
        runtime = "go113"
        region  = "asia-northeast1"
        environment_variables = {
          GCP_PROJECT = terraform.workspace
        }

        opt_var = {
          event_trigger     = true
          source_repository = true

          entry_point   = "StopAllGCEs"
          resource_type = "gcs_finalize"
          resource      = join("-", [terraform.workspace, "stopgce"])
          url = join("/", [
            "https://source.developers.google.com/projects",
            terraform.workspace,
            "repos",
            local.code_repo,
            "moveable-aliases/master/paths/",
            local.code_file_path,
            "gce_stop"
          ])
        }
      }

      pubsub_conf = [
        {
          enable = local.enable

          name     = "stopgce"
          opt_conf = {}
        }
      ]
      gcs_conf = [
        {
          enable = false

          name     = join("-", [terraform.workspace, "stopgce"])
          location = upper(local.region)
          opt_conf = {}
        }
      ]
    }
  ]
}
