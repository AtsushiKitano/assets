variable app_conf {
  type = object({
    runtime    = string
    version_id = string
    service    = string
    files = list(object({
      name       = string
      source_url = string
      sha1_sum   = string
    }))
  })
}

variable handlers {
  type = list(object({
    url_regex                   = string
    security_level              = string
    login                       = string
    auth_fail_action            = string
    redirect_http_response_code = string
    script                      = string
    static_files = list(object({
      path                 = string
      upload_path_regex    = string
      http_headers         = string
      mime_type            = string
      expiration           = string
      require_machine_file = string
      application_readable = string
    }))
  }))
  default = []
}
