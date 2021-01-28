variable "config" {
  type = object({
    name = string
    path = string
    access_key = object({
      status = string
    })
  })
}

/*
Option Configs
*/
variable "key" {
  type    = string
  default = null
}

variable "force_destroy" {
  type    = bool
  default = true
}

variable "iam_tags" {
  type    = map(string)
  default = {}
}
