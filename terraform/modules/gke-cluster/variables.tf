variable "cluster_name" {
  description = "GKE Cluster Name"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
}

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
  validation {
    condition     = contains(["DECRYPTED", "ENCRYPTED"], var.database_encryption_state)
    error_message = "The database_encryption_state must be either DECRYPTED or ENCRYPTED."
  }
}
