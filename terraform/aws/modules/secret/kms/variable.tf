variable "config" {
  type = object({
    name = string

    grants = list(object({
      name       = string
      role_arn   = string
      operations = list(string)
    }))
  })
}

/*
Option Config
*/

variable "description" {
  type    = string
  default = null
}

variable "key_usage" {
  type    = string
  default = "ENCRYPT_DECRYPT"
}

variable "key_spec" {
  type    = string
  default = "SYMMETRIC_DEFAULT"
}

variable "policy" {
  type    = string
  default = null
}

variable "deletion_window_in_days" {
  type    = number
  default = 30
}

variable "is_enabled" {
  type    = bool
  default = true
}

variable "enable_key_rotation" {
  type    = bool
  default = false
}

variable "key_tags" {
  type    = map(string)
  default = {}
}
