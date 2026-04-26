# Cluster Outputs
output "cluster_name" {
  description = "Cluster name"
  value       = module.gke_cluster.name
}

output "cluster_endpoint" {
  description = "Cluster endpoint"
  value       = module.gke_cluster.endpoint
}

output "cluster_ca_certificate" {
  description = "Cluster CA certificate"
  value       = module.gke_cluster.ca_certificate
}

output "cluster_master_auth" {
  description = "Cluster master authentication"
  value       = module.gke_cluster.master_auth
}

output "cluster_location" {
  description = "Cluster location"
  value       = module.gke_cluster.location
}

output "cluster_network" {
  description = "Cluster network"
  value       = module.gke_cluster.network
}

output "cluster_subnetwork" {
  description = "Cluster subnetwork"
  value       = module.gke_cluster.subnetwork
}

# Node Pool Outputs
output "node_pool_name" {
  description = "Node pool name"
  value       = module.node_pool.name
}

output "node_pool_id" {
  description = "Node pool ID"
  value       = module.node_pool.id
}

output "node_pool_status" {
  description = "Node pool status"
  value       = module.node_pool.status
}

output "node_pool_node_count" {
  description = "Number of nodes"
  value       = module.node_pool.node_count
}

output "node_pool_config" {
  description = "Node configuration"
  value       = module.node_pool.node_config
}

output "node_pool_autoscaling" {
  description = "Autoscaling configuration"
  value       = module.node_pool.autoscaling
}
