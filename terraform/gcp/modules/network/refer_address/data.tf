locals {
  type = {
    cloud      = "cloud-netblocks"
    google     = "google-netblocks"
    restricted = "restricted-googleapis"
    private    = "private-googleapis"
    dns        = "dns-forwarders"
    iap        = "iap-forwarders"
    health     = "health-checkers"
    lh         = "legacy-health-checkers"
    all        = null
  }
}

data "google_netblock_ip_ranges" "main" {
  range_type = local.type[var.range_type]
}
