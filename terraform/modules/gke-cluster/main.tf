terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.51.0"
    }
  }
}

resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region
  
  remove_default_node_pool = true
  initial_node_count       = 1

  network_policy {
    enabled = var.enable_network_policy
  }

  addons_config {
    http_load_balancing {
      disabled = !var.enable_http_load_balancing
    }
  }

  ip_allocation_policy {
    use_ip_aliases = var.use_ip_aliases
  }

  master_authorized_networks_config {
    cidr_blocks = var.master_authorized_networks
  }

  private_cluster_config {
    enable_private_nodes    = var.enable_private_nodes
    enable_private_endpoint = var.enable_private_endpoint
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  resource_usage_export_config {
    enable_network_egress_metering = var.enable_network_egress_metering
    enable_resource_consumption_metering = var.enable_resource_consumption_metering
  }

  dynamic "database_encryption" {
    for_each = var.database_encryption_key_name != null ? [1] : []
    content {
      key_name = var.database_encryption_key_name
      state    = var.database_encryption_state
    }
  }
}
