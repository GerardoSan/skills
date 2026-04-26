resource "google_container_node_pool" "node_pool" {
  name       = var.node_pool_name
  location   = var.region
  cluster    = var.cluster_name
  node_count = var.node_count

  node_config {
    machine_type = var.machine_type
    disk_size_gb = var.disk_size_gb
    disk_type    = var.disk_type
    
    oauth_scopes = var.oauth_scopes

    labels = var.labels

    tags = var.tags

    metadata = var.metadata

    service_account = var.service_account

    shielded_instance_config {
      enable_secure_boot          = var.enable_secure_boot
      enable_integrity_monitoring = var.enable_integrity_monitoring
    }

    sandbox_config {
      sandbox_type = var.sandbox_type
    }

    workload_metadata_config {
      mode = var.workload_metadata_mode
    }

    dynamic "guest_accelerator" {
      for_each = var.guest_accelerators
      content {
        type  = guest_accelerator.value.type
        count = guest_accelerator.value.count
      }
    }

    dynamic "reservation_affinity" {
      for_each = var.reservation_affinity != null ? [1] : []
      content {
        consume_reservation_type = var.reservation_affinity.consume_reservation_type
        key                      = lookup(var.reservation_affinity, "key", null)
        values                   = lookup(var.reservation_affinity, "values", null)
      }
    }
  }

  management {
    auto_repair  = var.auto_repair
    auto_upgrade = var.auto_upgrade
  }

  upgrade_settings {
    max_surge       = var.max_surge
    max_unavailable = var.max_unavailable
  }

  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }

  max_pods_per_node = var.max_pods_per_node

  dynamic "node_locations" {
    for_each = var.node_locations != null ? [1] : []
    content {
      zones = var.node_locations
    }
  }
}
