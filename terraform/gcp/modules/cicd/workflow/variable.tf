/*
   Required Configs
*/
variable "name" {
  type = string
}

variable "project" {
  type = string
}

variable "source_contents" {
  type        = string
  description = "Workflow Source yaml file path."
}

/*
  Option Configs
*/
variable "roles" {
  type    = list(string)
  default = ["roles/editor"]
}

variable "region" {
  type    = string
  default = "asia-northeast1"
}

variable "description" {
  type    = string
  default = "Created By Terraform"
}

variable "enabled_schedulering" {
  type    = bool
  default = true
}

variable "schedule" {
  type    = string
  default = "0 22 * * *"
}

variable "time_zone" {
  type    = string
  default = "Asia/Tokyo"
}

variable "body" {
  type    = string
  default = "Default Value created by Terraform"
}
