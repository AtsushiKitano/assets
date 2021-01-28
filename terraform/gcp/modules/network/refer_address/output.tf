output "gcp_ip_ranges" {
  value = data.google_netblock_ip_ranges.main.cidr_blocks_ipv4
}

output "gcp_ip_all_ranges" {
  value = data.google_netblock_ip_ranges.main.cidr_blocks
}

output "gcp_ip_v6_ranges" {
  value = data.google_netblock_ip_ranges.main.cidr_blocks_ipv6
}
