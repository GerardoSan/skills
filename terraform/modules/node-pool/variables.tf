variable "node_pool_name" {
  description = "Node pool name"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
}

variable "cluster_name" {
  description = "Cluster name"
  type        = string
}

variable "node_count" {
  description = "Number of nodes"
  type        = number
  default     = 1
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
  validation {
    condition     = contains(["pd-standard", "pd-ssd", "pd-balanced"], var.disk_type)
    error_message = "The disk_type must be one of: pd-standard, pd-ssd, pd-balanced."
  }
}

variable "oauth_scopes" {
  description = "OAuth scopes"
  type        = list(string)
  default = [
    "https://www.googleapis.com/auth/cloud-platform"
  ]
}

variable "labels" {
  description = "Labels for node pool"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags for node pool"
  type        = list(string)
  default     = []
}

variable "metadata" {
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
  validation {
    condition     = contains(["gvisor", "none"], var.sandbox_type)
    error_message = "The sandbox_type must be either gvisor or none."
  }
}

variable "workload_metadata_mode" {
  description = "Workload metadata mode"
  type        = string
  default     = "GKE_METADATA"
  validation {
    condition     = contains(["GKE_METADATA", "GCE_METADATA"], var.workload_metadata_mode)
    error_message = "The workload_metadata_mode must be either GKE_METADATA or GCE_METADATA."
  }
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
