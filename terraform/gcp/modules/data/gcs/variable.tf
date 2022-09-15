variable "name" {
  type = string
}

variable "location" {
  type = string
}


/*
Option Configurations
*/

variable "objects" {
  type = list(object({
    name   = string
    source = string
  }))
  default = []
}

variable "cache_control" {
  type    = map(string)
  default = null
}

variable "content_disposition" {
  type    = map(string)
  default = null
}

variable "content_encoding" {
  type    = map(string)
  default = null
}

variable "content_language" {
  type    = map(string)
  default = null
}

variable "content_type" {
  type    = map(string)
  default = null
}

variable "project" {
  type    = string
  default = null
}

variable "storage_class" {
  type    = string
  default = "STANDARD"
}

variable "versioning" {
  type    = bool
  default = false
}

variable "force_destroy" {
  type    = bool
  default = true
}

variable "website" {
  type = object({
    main_page_suffix = string
    not_found_page   = string
  })
  default = null
}

variable "cors" {
  type = object({
    origin          = list(string)
    method          = list(string)
    response_header = list(string)
    max_age_seconds = number
  })
  default = null
}


variable "enabled_lifecycle" {
  type    = bool
  default = false
}

variable "lifecycle_conf" {
  type = object({
    type = string
    condition = object({
      age            = number
      matches_prefix = list(string)
    })
  })
  default = null
}
