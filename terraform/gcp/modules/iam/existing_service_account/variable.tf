variable "service_account" {
  type = string
}

variable "project_iam_roles" {
  type = list(object({
    project = string
    roles   = list(string)
  }))
}
