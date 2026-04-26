terraform {
  backend "gcs" {
    bucket = "terraform-state-${var.project_id}"
    prefix = "gke-cluster"
    
    # Enable versioning and locking
    encryption_key = var.state_encryption_key
    
    # Optional: Configure for multi-region
    # location = "US"
  }
}

# Data source for client configuration
data "google_client_config" "default" {}
