variable "net_conf" {
  type = object({
    name = string
    datas = list(object({
      ip = string
    }))
  })

  default = {
    name = "test"
    datas = [
      {
        ip = "192.13"
      },
      {
        ip = "12.34.32"
      }
    ]
  }
}

# output "net_conf" {
#   value = var.net_conf
# }
