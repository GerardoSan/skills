# GKE Cluster Module
module "gke_cluster" {
  source = "./modules/gke-cluster"

  cluster_name                   = var.cluster_name
  region                         = var.region
  enable_network_policy          = var.enable_network_policy
  enable_http_load_balancing     = var.enable_http_load_balancing
  use_ip_aliases                 = var.use_ip_aliases
  master_authorized_networks     = var.master_authorized_networks
  enable_private_nodes           = var.enable_private_nodes
  enable_private_endpoint        = var.enable_private_endpoint
  master_ipv4_cidr_block         = var.master_ipv4_cidr_block
  enable_network_egress_metering = var.enable_network_egress_metering
  enable_resource_consumption_metering = var.enable_resource_consumption_metering
  database_encryption_key_name    = var.database_encryption_key_name
  database_encryption_state      = var.database_encryption_state
}

module "node_pool" {
  source = "./modules/node-pool"

  node_pool_name          = var.node_pool_name
  region                  = var.region
  cluster_name            = module.gke_cluster.name
  node_count              = var.node_count
  machine_type            = var.machine_type
  disk_size_gb            = var.disk_size_gb
  disk_type               = var.disk_type
  oauth_scopes            = var.oauth_scopes
  labels                  = var.node_labels
  tags                    = var.node_tags
  metadata                = var.node_metadata
  service_account         = var.service_account
  enable_secure_boot      = var.enable_secure_boot
  enable_integrity_monitoring = var.enable_integrity_monitoring
  sandbox_type            = var.sandbox_type
  workload_metadata_mode  = var.workload_metadata_mode
  guest_accelerators      = var.guest_accelerators
  reservation_affinity    = var.reservation_affinity
  auto_repair             = var.auto_repair
  auto_upgrade            = var.auto_upgrade
  max_surge               = var.max_surge
  max_unavailable         = var.max_unavailable
  min_node_count          = var.min_node_count
  max_node_count          = var.max_node_count
  max_pods_per_node       = var.max_pods_per_node
  node_locations          = var.node_locations
}
