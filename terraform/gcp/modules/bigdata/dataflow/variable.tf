variable "dataflow_conf" {
  type = list(object({
    enable = bool

    job_conf = list(object({
      name                  = string
      template_gcs_path     = string
      temp_gcs_location     = string
      network               = string
      region                = string
      zone                  = string
      subnetwork            = string
      machine_type          = string
      service_account_email = string
      params                = map(string)

      opt_conf = map(string)
    }))
  }))
}
