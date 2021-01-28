locals {
  app_sample_enabled = false
  app_gcs_path       = "https://storage.googleapis.com/ca-kitano-study-sandbox-appengine-test/"

  _app_sample_conf = local.app_sample_enabled ? [
    {
      service    = "hello-world"
      runtime    = "go115"
      version_id = "v1"

      files = [
        {
          name       = "main.go"
          source_url = join("", [local.app_gcs_path, "main.go"])
          sha1_sum   = "f066e47ad95a917441b20708d05682f124343ed6"
        },
        {
          name       = "go.mod"
          source_url = join("", [local.app_gcs_path, "go.mod"])
          sha1_sum   = "b46819b14deb53c8ba233be0abd4dd66ef975acb"
        }
      ]
    }
  ] : []
}

module "app_st_sample" {
  for_each = { for v in local._app_sample_conf : v.service => v }
  source   = "../modules/compute/gae"

  app_conf = each.value
}
