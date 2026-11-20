variable "project_id" {
  description = "GCP Project ID where the compute instance will be deployed"
  type        = string
}

variable "project_prefix" {
  description = "Prefix used for naming compute resources"
  type        = string
  default     = "hcl-tf"
}

variable "environment" {
  description = "Deployment environment (dev or prod)"
  type        = string

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "Environment must be either 'dev' or 'prod'."
  }
}

variable "zone" {
  description = "GCP zone for the compute instance"
  type        = string
  default     = "us-central1-a"
}

variable "machine_type" {
  description = "GCE machine type (e2-micro is eligible for GCP Always Free tier)"
  type        = string
  default     = "e2-micro"

  validation {
    condition     = contains(["e2-micro", "e2-small", "e2-medium"], var.machine_type)
    error_message = "Allowed machine types for cost governance are e2-micro, e2-small, or e2-medium."
  }
}

variable "subnet_self_link" {
  description = "Self link of the subnetwork from the networking module"
  type        = string
}

variable "service_account_email" {
  description = "Least-privilege service account email from the IAM module"
  type        = string
}

variable "artifacts_bucket_name" {
  description = "GCS bucket name from the storage module passed to instance metadata"
  type        = string
}

variable "enable_public_ip" {
  description = "Whether to assign an ephemeral public IP (disabled by default for security)"
  type        = bool
  default     = false
}

variable "labels" {
  description = "Additional labels to apply to the compute instance"
  type        = map(string)
  default     = {}
}
