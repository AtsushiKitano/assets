variable "bucket" {
  type = object({
    name     = string
    location = string
  })
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

variable "lifecycle_rule" {
  type = object({
    action    = string
    condition = string
  })
  default = null
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
