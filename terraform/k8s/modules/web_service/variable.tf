variable "metadata" {
  type = object({
    dep = object({
      name   = string
      labels = map(string)
    })
    lab = object({
      labels = map(string)
    })
    sv = object({
      name = string
    })
  })
}

variable "deployment" {
  type = object({
    replicas     = number
    match_labels = map(string)
    img          = string
    name         = string
    limits = object({
      cpu    = string
      memory = string
    })
    requests = object({
      cpu    = string
      memory = string
    })
  })
}

variable "service" {
  type = object({
    type             = string
    session_affinity = string
    selector         = map(string)
    port             = number
  })
}
