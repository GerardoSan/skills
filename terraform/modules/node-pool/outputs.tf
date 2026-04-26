output "name" {
  description = "Node pool name"
  value       = google_container_node_pool.node_pool.name
}

output "id" {
  description = "Node pool ID"
  value       = google_container_node_pool.node_pool.id
}

output "status" {
  description = "Node pool status"
  value       = google_container_node_pool.node_pool.status
}

output "node_count" {
  description = "Number of nodes"
  value       = google_container_node_pool.node_pool.node_count
}

output "node_config" {
  description = "Node configuration"
  value       = google_container_node_pool.node_pool.node_config
}

output "autoscaling" {
  description = "Autoscaling configuration"
  value       = google_container_node_pool.node_pool.autoscaling
}
