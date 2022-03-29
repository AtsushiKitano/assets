output "cluster_id" {
  value = google_container_cluster.main.id
}

output "cluster" {
  value = google_container_cluster.main
}

output "nodes" {
  value = { for v in var.node_pools : v.name => google_container_node_pool.main[v.name] if var.enable_autopilot == null }
}
