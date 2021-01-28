locals {
  json_network_sample_enable = false

  _json_network_enable = local.json_network_sample_enable ? ["enable"] : []
}

module "json_network_sample" {
  for_each = toset(local._json_network_enable)
  source   = "../modules/inheritance_module/file_input_modules/json_network"

  file_path = "./files/network_object.json"
}
