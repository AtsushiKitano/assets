build {
  sources = [
    "source.googlecompute.nginx"
  ]
  provisioner "ansible" {
    playbook_file   = "./scripts/ansible-playbook.yaml"
    user            = "packer"
    extra_arguments = ["-vvvv"]
  }
  provisioner "inspec" {
    profile = "./test"
    extra_arguments = [
      "--sudo",
      "--chef-license=accept"
    ]
  }
}
