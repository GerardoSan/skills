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

# GKE Cluster Variables
variable "enable_network_policy" {
  description = "Enable network policy"
  type        = bool
  default     = true
}

variable "enable_http_load_balancing" {
  description = "Enable HTTP load balancing"
  type        = bool
  default     = true
}

variable "use_ip_aliases" {
  description = "Use IP aliases"
  type        = bool
  default     = true
}

variable "master_authorized_networks" {
  description = "Master authorized networks"
  type        = list(object({
    display_name = string
    cidr_block   = string
  }))
  default = []
}

variable "enable_private_nodes" {
  description = "Enable private nodes"
  type        = bool
  default     = false
}

variable "enable_private_endpoint" {
  description = "Enable private endpoint"
  type        = bool
  default     = false
}

variable "master_ipv4_cidr_block" {
  description = "Master IPv4 CIDR block"
  type        = string
  default     = ""
}

variable "enable_network_egress_metering" {
  description = "Enable network egress metering"
  type        = bool
  default     = false
}

variable "enable_resource_consumption_metering" {
  description = "Enable resource consumption metering"
  type        = bool
  default     = false
}

variable "database_encryption_key_name" {
  description = "Database encryption key name"
  type        = string
  default     = null
}

variable "database_encryption_state" {
  description = "Database encryption state"
  type        = string
  default     = "DECRYPTED"
}

# Node Pool Variables
variable "node_pool_name" {
  description = "Node pool name"
  type        = string
  default     = "default-node-pool"
}

variable "node_count" {
  description = "Number of nodes"
  type        = number
  default     = 2
}

variable "machine_type" {
  description = "Machine type"
  type        = string
  default     = "e2-medium"
}

variable "disk_size_gb" {
  description = "Disk size in GB"
  type        = number
  default     = 100
}

variable "disk_type" {
  description = "Disk type"
  type        = string
  default     = "pd-standard"
}

variable "oauth_scopes" {
  description = "OAuth scopes"
  type        = list(string)
  default = [
    "https://www.googleapis.com/auth/cloud-platform"
  ]
}

variable "node_labels" {
  description = "Labels for node pool"
  type        = map(string)
  default     = {}
}

variable "node_tags" {
  description = "Tags for node pool"
  type        = list(string)
  default     = []
}

variable "node_metadata" {
  description = "Metadata for node pool"
  type        = map(string)
  default     = {}
}

variable "service_account" {
  description = "Service account for nodes"
  type        = string
  default     = ""
}

variable "enable_secure_boot" {
  description = "Enable secure boot"
  type        = bool
  default     = true
}

variable "enable_integrity_monitoring" {
  description = "Enable integrity monitoring"
  type        = bool
  default     = true
}

variable "sandbox_type" {
  description = "Sandbox type"
  type        = string
  default     = "gvisor"
}

variable "workload_metadata_mode" {
  description = "Workload metadata mode"
  type        = string
  default     = "GKE_METADATA"
}

variable "guest_accelerators" {
  description = "Guest accelerators"
  type = list(object({
    type  = string
    count = number
  }))
  default = []
}

variable "reservation_affinity" {
  description = "Reservation affinity"
  type = object({
    consume_reservation_type = string
    key                      = optional(string)
    values                   = optional(list(string))
  })
  default = null
}

variable "auto_repair" {
  description = "Enable auto repair"
  type        = bool
  default     = true
}

variable "auto_upgrade" {
  description = "Enable auto upgrade"
  type        = bool
  default     = true
}

variable "max_surge" {
  description = "Max surge for upgrade"
  type        = number
  default     = 1
}

variable "max_unavailable" {
  description = "Max unavailable for upgrade"
  type        = number
  default     = 0
}

variable "min_node_count" {
  description = "Min node count for autoscaling"
  type        = number
  default     = 1
}

variable "max_node_count" {
  description = "Max node count for autoscaling"
  type        = number
  default     = 3
}

variable "max_pods_per_node" {
  description = "Max pods per node"
  type        = number
  default     = 110
}

variable "node_locations" {
  description = "Node locations"
  type        = list(string)
  default     = null
}

# Backend and State Variables
variable "state_encryption_key" {
  description = "Encryption key for Terraform state"
  type        = string
  default     = ""
}

variable "gcs_bucket_name" {
  description = "GCS bucket name for Terraform state"
  type        = string
  default     = ""
}
