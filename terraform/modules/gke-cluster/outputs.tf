output "name" {
  description = "Cluster name"
  value       = google_container_cluster.primary.name
}

output "endpoint" {
  description = "Cluster endpoint"
  value       = google_container_cluster.primary.endpoint
}

output "ca_certificate" {
  description = "Cluster CA certificate"
  value       = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
}

output "master_auth" {
  description = "Cluster master authentication"
  value       = google_container_cluster.primary.master_auth
}

output "location" {
  description = "Cluster location"
  value       = google_container_cluster.primary.location
}

output "network" {
  description = "Cluster network"
  value       = google_container_cluster.primary.network
}

output "subnetwork" {
  description = "Cluster subnetwork"
  value       = google_container_cluster.primary.subnetwork
}
