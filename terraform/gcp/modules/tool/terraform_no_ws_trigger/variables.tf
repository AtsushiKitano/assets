################################
#######Required Configs#########
################################
variable "name" {
  type = string
}

variable "repository" {
  type = string
}

variable "plan_filename" {
  type = string
}

variable "apply_filename" {
  type = string
}

variable "github_owner" {
  type = string
}

################################
#######Option Configs###########
################################
variable "default_branch" {
  type    = string
  default = "main"
}

variable "substitutions" {
  type    = map(string)
  default = null
}

variable "ignored_files" {
  type    = list(string)
  default = ["README.md", ".gitignore"]
}

variable "project" {
  type    = string
  default = null
}
