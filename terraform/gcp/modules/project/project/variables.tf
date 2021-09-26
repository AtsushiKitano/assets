######################################
######## Required Config #############
######################################
variable "project_id" {
  type = string
}

variable "service_apis" {
  type = list(string)
}

variable "billing_account" {
  type = string
}

variable "folder_id" {
  type = string
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

variable "project_name" {
  type    = string
  default = null
}
