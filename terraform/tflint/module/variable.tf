variable "tags" {
  type    = list(string)
  default = []
}

variable "labels" {
  type    = map(string)
  default = {}
}

variable "name" {
  type = string
}

variable "machine_type" {
  type    = string
  default = "f1-micro"
}


variable "zone" {
  type    = string
  default = "asia-northeast1-b"
}

variable "subnetwork" {
  type    = string
  default = "default"
}

variable "image" {
  type    = string
  default = "debian-cloud/debian-9"
}
