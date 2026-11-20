variable "project_id" {
  description = "GCP Project ID where IAM resources will be created"
  type        = string
}

variable "project_prefix" {
  description = "Prefix used for naming IAM service accounts"
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

variable "iam_roles" {
  description = "List of least-privilege IAM roles assigned to the application service account"
  type        = list(string)
  default = [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/storage.objectViewer"
  ]

  validation {
    condition     = length(var.iam_roles) > 0
    error_message = "At least one IAM role must be provided for the service account."
  }
}
