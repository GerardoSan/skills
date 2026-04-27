variable "project_id" {
  description = "GCP Project ID"
  type        = string
  default     = "project-03383fe2-d85a-4d7c-bea"
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
