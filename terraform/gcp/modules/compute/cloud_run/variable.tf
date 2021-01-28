variable "config" {
  type = object({
    name     = string
    location = string
    spec = object({
      container_concurrency = number
      timeout_seconds       = number
    })
    containers = object({
      args    = list(string)
      image   = string
      command = list(string)
    })
  })
}


########################################
#  Option Value
########################################
variable "domain" {
  type = object({
    name     = string
    location = string
  })
  default = null
}

variable "domain_spec" {
  type = object({
    certificate_mode = string
    force_override   = string
  })
  default = null
}

variable "domain_metadata" {
  type = object({
    annotations      = map(string)
    labels           = map(string)
    generation       = string
    resource_version = string
  })
  default = null
}

variable "service_account" {
  type    = string
  default = null
}

variable "serving_state" {
  type    = string
  default = null
}

variable "traffic" {
  type = object({
    percent       = number
    revision_name = string
  })
  default = null
}

variable "project" {
  type    = string
  default = null
}

variable "annotations" {
  type    = map(string)
  default = null
}

variable "autogenerate_revision_name" {
  type    = bool
  default = false
}

variable "metadata" {
  type = object({
    labels           = map(string)
    generation       = string
    resource_version = string
    name             = string
  })
  default = null
}

variable "resources" {
  type = object({
    limits   = map(string)
    requests = map(string)
  })
  default = null
}

variable "secret_ref" {
  type = list(object({
    optional = string
    local_object_reference = object({
      name = string
    })
  }))
  default = []
}

variable "config_map_ref" {
  type = list(object({
    optional = string
    local_object_reference = object({
      name = string
    })
  }))
  default = []
}

variable "env" {
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "ports" {
  type = list(object({
    name           = string
    protocol       = string
    container_port = number
  }))
  default = []
}

variable "env_from" {
  type = object({
    prefix = string
  })
  default = null
}
