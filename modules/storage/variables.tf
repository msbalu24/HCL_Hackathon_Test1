variable "project_id" {
  description = "GCP Project ID where the storage bucket will be created"
  type        = string
}

variable "project_prefix" {
  description = "Prefix used for naming storage resources"
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

variable "location" {
  description = "GCP location/region for the storage bucket"
  type        = string
  default     = "US"
}

variable "force_destroy" {
  description = "Allow Terraform to destroy the bucket even if it contains objects"
  type        = bool
  default     = true
}

variable "lifecycle_age_days" {
  description = "Number of days after which old objects are automatically deleted"
  type        = number
  default     = 30

  validation {
    condition     = var.lifecycle_age_days >= 1 && var.lifecycle_age_days <= 365
    error_message = "Lifecycle age must be between 1 and 365 days."
  }
}

variable "labels" {
  description = "Additional labels to apply to the storage bucket"
  type        = map(string)
  default     = {}
}
