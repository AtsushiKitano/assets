variable "file_path" {
  type = string
  default = "./input.yaml"
}

# variable "network_conf" {
#   type = list(object({
#     vpc_network_enable      = bool
#     subnetwork_enable       = bool

#     vpc_network_conf = object({
#       name                    = string
#       auto_create_subnetworks = bool
#     })

#     subnetwork = list(object({
#       name   = string
#       cidr   = string
#       region = string
#     }))
#   }))
# }

