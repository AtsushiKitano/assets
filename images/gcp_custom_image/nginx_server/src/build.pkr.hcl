build {
  sources = [
    "source.googlecompute.nginx"
  ]
  provisioner "ansible" {
    playbook_file   = "../scripts/ansible-playbook.yaml"
    user            = "packer"
    extra_arguments = ["-vvvv"]
  }
}
