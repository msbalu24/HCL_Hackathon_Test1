variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "project_prefix" {
  description = "Resource naming prefix"
  type        = string
  default     = "hcl-tf"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone"
  type        = string
  default     = "us-central1-a"
}

variable "subnet_cidr" {
  description = "CIDR block for Dev subnet"
  type        = string
  default     = "10.10.1.0/24"
}

variable "machine_type" {
  description = "GCE machine type for Dev"
  type        = string
  default     = "e2-micro"
}
