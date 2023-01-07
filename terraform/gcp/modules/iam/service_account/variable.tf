variable "name" {
  type = string
}

variable "roles" {
  type = list(string)
}


/*
Config Variables
*/

variable "condition" {
  type = object({
    expression = string
    title      = string
  })
  default = null
}

variable "display_name" {
  type    = string
  default = null
}

variable "description" {
  type    = string
  default = null
}

variable "project" {
  type = string
}

variable "pubsub_topic_iam_bindings" {
  type = list(object({
    project = string
    name    = string
    roles   = list(string)
  }))
  default = []
}

variable "cloud_run_iam_bindings" {
  type = list(object({
    service = string
    role    = string
    project = string
  }))
  default = []
}
