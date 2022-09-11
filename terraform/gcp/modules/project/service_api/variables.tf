/*
  Required Config
*/

variable "project" {
  type = string
}

variable "service_apis" {
  type = list(string)
}


/*
  Option Config
*/

variable "disable_on_destroy" {
  type    = bool
  default = true
}

variable "disable_dependent_services" {
  type    = bool
  default = true
}
