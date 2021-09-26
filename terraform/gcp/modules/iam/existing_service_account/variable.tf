variable "service_account" {
  type = string
}

variable "project_iam_roles" {
  type = list(object({
    project = string
    roles   = list(string)
  }))
}

variable "organization_iam_roles" {
  type    = list(string)
  default = []
}

variable "folder_iam_roles" {
  type = list(object({
    folder_id = string
    roles     = list(string)
  }))
  default = []
}
