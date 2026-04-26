terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.51.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Provider configuration for GitHub Actions OIDC
provider "google" {
  alias = "github"
  project = var.project_id
  region  = var.region
  
  # Use Workload Identity Federation for GitHub Actions
  access_token = data.google_client_config.default.access_token
}
