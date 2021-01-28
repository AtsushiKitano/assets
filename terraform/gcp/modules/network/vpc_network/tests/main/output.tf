output "test" {
  value = module.network["test"].name
}

output "self_link" {
  value = module.network["test"].self_link
}

output "subnet" {
  value = module.network["test"].subnetwork_name
}

