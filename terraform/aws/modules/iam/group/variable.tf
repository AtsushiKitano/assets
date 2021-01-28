variable "config" {
  type = object({
    name = string
    path = string
    membership = object({
      name  = string
      users = list(string)
    })
  })
}
