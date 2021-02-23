variable "conf" {
  type = object({
    display_name = string
    timeout      = string
    period       = string
    combiner     = string
  })
}

variable "http_check" {
  type = object({
    request_method = string
    content_type   = string
    port           = string
    headers        = map(string)
    path           = string
    use_ssl        = bool
    mask_headers   = bool
    validate_ssl   = string
    body           = string
  })
}

variable "conditions" {
  type = list(object({
    name         = string
    display_name = string
    duration     = string
    trigger = object({
      type  = string
      value = number
    })

    aggregations = object({
      per_series_aligner   = string
      group_by_fields      = list(string)
      alignment_period     = string
      cross_series_reducer = string
    })

    condition_threshold = object({
      comparison      = string
      threshold_value = string
    })

  }))
}

/*
Option Value
*/
variable "content_mathers" {
  type = object({
    content = string
    matcher = string
  })
  default = null
}

variable "auth_info" {
  type = object({
    password = string
    username = string
  })

  default = null
}

variable "regions" {
  type    = list(string)
  default = []
}

variable "project" {
  type    = string
  default = null
}

variable "tcp_check" {
  type = object({
    port = string
  })
  default = null
}

variable "resource_group" {
  type = object({
    resource_type = string
    group_id      = string
  })
  default = null
}


variable "monitored_resource" {
  type = object({
    type   = string
    labels = map(string)
  })
  default = null
}

variable "content_matchers" {
  type = object({
    content = string
    matcher = string
  })
  default = null
}

variable "enabled" {
  type    = bool
  default = true
}

variable "notification_channels" {
  type    = list(string)
  default = []
}

variable "document" {
  type = object({
    content   = string
    mime_type = string
  })
  default = null
}
