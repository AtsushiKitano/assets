locals {
  fws = [
    for v in module.main["test"].firewall.test-ingress.allow : v
  ]
}

output "test" {
  value = module.main["test"].name
}

output "subnet" {
  value = module.main["test"].subnetwork_name
}

output "fw" {
  value = module.main["test"].firewall
}

output "fw_name" {
  value = flatten([
    for v in local._insple_test : [
      for w in v.firewalls : w.name
    ]
  ])
}

output "input_fw_network" {
  value = module.main["test"].firewall.test-ingress.network
}

output "input_fw_direction" {
  value = module.main["test"].firewall.test-ingress.direction
}

output "input_fw_allow_rules" {
  value = local.fws[0].protocol
}

output "input_fw_deny_rules" {
  value = module.main["test"].firewall.test-ingress.deny
}

output "input_fw_log_config" {
  value = module.main["test"].firewall.test-ingress.log_config[0].metadata
}

output "input_fw_log_all_config" {
  value = module.main["test"].firewall.test-ingress.log_config
}

output "input_fw_target_tags" {
  value = module.main["test"].firewall.test-ingress.target_tags
}
