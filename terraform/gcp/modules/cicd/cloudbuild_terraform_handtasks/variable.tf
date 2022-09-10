/*
  Required Configs
*/

variable "name" {
  type = string
}

variable "cloud_build_dir_path" {
  type = string
}

variable "repo" {
  type = object({
    owner = string
    name  = string
  })
}

variable "project" {
  type = string
}

variable "region" {
  type = string
}

/*
  Option Configs
*/

variable "repo_type" {
  type    = string
  default = "GITHUB"
}

variable "ref" {
  type    = string
  default = "refs/heads/main"
}

variable "log_bucket" {
  type    = string
  default = "terraform-log"
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
  default = "eyJzb3VyY2UiOnsiYnJhbmNoTmFtZSI6Im1haW4ifX0="
}

variable "service_account" {
  type    = string
  default = "cloud-build-tf-trigger"
}

variable "terraform_apply_file" {
  type    = string
  default = "terraform_apply.yaml"
}

variable "terraform_plan_file" {
  type    = string
  default = "terraform_plan.yaml"
}

variable "terraform_destroy_file" {
  type    = string
  default = "terraform_destroy.yaml"
}

variable "substitutions" {
  type    = map(string)
  default = null
}

variable "enabled_delete_scheduler_job" {
  type    = bool
  default = true
}

variable "disabled_plan_task" {
  type    = bool
  default = false
}
