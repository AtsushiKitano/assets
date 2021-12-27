######################################
######## Required Config #############
######################################
variable "project" {
  type = object({
    id              = string
    name            = string
    billing_account = string
    folder_id       = string
  })
}

variable "enable_service_apis" {
  type = list(string)
}
######################################
######## Option Config ###############
######################################
variable "skip_delete" {
  type    = bool
  default = false
}

variable "auto_create_network" {
  type    = bool
  default = false
}

variable "disable_dependent_services" {
  type    = bool
  default = true
}

variable "disable_on_destroy" {
  type    = bool
  default = true
}
