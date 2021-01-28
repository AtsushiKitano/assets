build {
  sources = [
    "source.googlecompute.docker-vm"
  ]
  provisioner "ansible" {
    playbook_file   = "./packer/scripts/ansible-playbook.yaml"
    user            = local.user
    extra_arguments = ["-vvvv"]
  }
}
