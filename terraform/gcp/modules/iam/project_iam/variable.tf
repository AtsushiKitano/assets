variable "iam_conf" {
  type = object({
    email       = string
    member_type = string
    roles       = list(string)
  })
}

/*
Option Conditions
*/

variable "condition" {
  type = object({
    expression = string
    title      = string
  })
  default = null
}

variable "project" {
  type    = string
  default = null
}

