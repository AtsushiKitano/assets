locals {
  enables = {
    prd = true
    stg = false
    dev = false
  }

}

output "test23" {
  value = local._conf
}
