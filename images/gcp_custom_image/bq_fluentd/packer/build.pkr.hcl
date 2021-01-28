build {
  sources = [
    "source.googlecompute.bq_fluentd"
  ]

  provisioner "ansible" {
    playbook_file   = "./packer/scripts/ansible-playbook.yaml"
    user            = local.user
    extra_arguments = ["-vvvv"]
  }
}
