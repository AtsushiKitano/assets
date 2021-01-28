build {
  sources = [
    "source.googlecompute.nested"
  ]
  provisioner "ansible" {
    playbook_file   = "./packer/scripts/ansible-playbook.yaml"
    user            = local.user
    extra_arguments = ["-vvvv"]
  }
  provisioner "inspec" {
    profile         = "./packer/test"
    extra_arguments = [
      "--sudo",
      "--chef-license=accept"
    ]
  }
}
