variable "project_id" {
  description = "GCP Project ID"
  type        = string
  default     = "your-project-id"
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "us-central1"
}

variable "cluster_name" {
  description = "GKE Cluster Name"
  type        = string
  default     = "web-app-cluster"
}
