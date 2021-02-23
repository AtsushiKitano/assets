variable "conf" {
  type = object({
    display_name = string
    combiner     = string
  })
}

variable "conditions" {
  type = list(object({
    name         = string
    filter       = string
    display_name = string
    absent       = bool
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
Option Config
*/
variable "project" {
  type    = string
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
