include {
  path = find_in_parent_folders()
}

dependency "network" {
  config_path = "../network"
  skip_outputs = get_env("SKIP_OUTPUT")

  mock_outputs = {
    sub = "module.network.subnetwork_self_link"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "workspace"]
}

inputs = {
  subnet_self_link = dependency.network.outputs.sub
}
