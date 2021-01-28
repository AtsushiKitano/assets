resource "null_resource" "get" {
  provisioner "local-exec" {
    command = "echo hello"
  }
}

output "test" {
  value = null_resource.get.id
}
