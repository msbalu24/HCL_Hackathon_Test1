variable "project_id" {
  description = "GCP Project ID where networking resources will be provisioned"
  type        = string
}

variable "project_prefix" {
  description = "Prefix used for naming all networking resources"
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

variable "region" {
  description = "GCP region for the subnetwork"
  type        = string
  default     = "us-central1"
}

variable "subnet_cidr" {
  description = "CIDR IP range for the primary subnetwork"
  type        = string

  validation {
    condition     = can(cidrhost(var.subnet_cidr, 0))
    error_message = "Must be a valid IPv4 CIDR block (e.g., 10.10.1.0/24)."
  }
}
