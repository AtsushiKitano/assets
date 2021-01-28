locals {
  file_network_sample_enable = false

  _file_nw_sample = local.file_network_sample_enable ? ["enable"] : []
}

module "file_network_sample" {
  for_each = toset(local._file_nw_sample)
  source   = "../modules/inheritance_module/file_input_modules/csv_network"

  firewall_file = "./files/firewall.csv"
  network_file  = "./files/vpc_network.csv"
}
