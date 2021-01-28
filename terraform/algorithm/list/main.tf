locals {
  tests = [
    {
      type     = "allow"
      ports    = ["22"]
      protocol = "tcp"
    },
    {
      type     = "allow"
      ports    = ["80"]
      protocol = "tcp"
    },
    {
      type     = "deny"
      ports    = ["80"]
      protocol = "tcp"
    },
  ]

  samples = flatten([
    for v in local.tests : v.type == "allow" ? [v] : []
  ])
}

output "samples" {
  value = local.samples
}
