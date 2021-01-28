locals {
  iam_enable = false

  _iam_enable = local.iam_enable ? ["enable"] : []
}

module "iam_sample" {
  for_each = toset(local._iam_enable)
  source   = "../modules/iam/project_iam"

  iam_conf = {
    email       = ""
    member_type = "user"
    roles       = ["editor"]
  }
}
