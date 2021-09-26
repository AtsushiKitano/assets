#########################################################
# Required arguments
#########################################################
variable "project_id" {
  type = string
}

variable "services" {
  type = list(string)
}

#########################################################
# Optional arguments
#########################################################
variable "kms_key_ring_iam_roles" {
  type = list(object({
    key_ring_id = string
    role        = string
  }))
  default = []
}

variable "kms_crypto_key_iam_roles" {
  type = list(object({
    crypto_key_id = string
    role          = string
  }))
  default = []
}

variable "artifact_registry_repository_iam_roles" {
  type = list(object({
    project    = string
    location   = string
    repository = string
    role       = string
  }))
  default = []
}
