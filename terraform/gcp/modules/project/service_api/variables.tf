variable "services" {
  type = list(string)
}

variable "project" {
  type = string
}

variable "timeouts" {
  type = object({
    create = string
    update = string
  })
  default = null
}

variable "disable_dependent_services" {
  type    = bool
  default = false
}

variable "disable_on_destroy" {
  type    = bool
  default = false
}
