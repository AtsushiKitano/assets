locals {
  _conf = distinct(flatten([
    for _conf_iam in var.iam : [
      for _conf_role in _conf_iam.roles : {
        email = _conf_iam.email
        role  = _conf_role
      }
    ]
  ]))
}

variable "iam" {
  type = list(object({
    email = string
    roles = list(string)
  }))

  default = [
    {
      email = "test@test"
      roles = [
        "roles/viwer",
        "roles/admin"
      ]
    },
    {
      email = "test2@test"
      roles = [
        "roles/viwer",
        "roles/admin"
      ]
    }
  ]
}

output "test_iam_role_sample" {
  value = local._conf
}
