variable "service_account" {
  type = object({
    name  = string
    roles = list(string)
  })
}

/*
Config Variables
*/

variable "condition" {
  type = object({
    expression = string
    title      = string
  })
  default = null
}

variable "display_name" {
  type    = string
  default = null
}

variable "description" {
  type    = string
  default = null
}

variable "project" {
  type    = string
  default = null
}
