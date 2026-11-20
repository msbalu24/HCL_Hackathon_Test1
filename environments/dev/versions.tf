terraform {
  required_version = ">= 1.5.0"

  cloud {
    organization = "balu-hcl-tf-org"

    workspaces {
      name = "gcp-infra-dev"
    }
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.40"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4.4"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

provider "vault" {
  address         = var.vault_address
  skip_tls_verify = true
}
