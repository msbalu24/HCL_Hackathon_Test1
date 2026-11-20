locals {
  mandatory_labels = {
    environment = var.environment
    owner       = "balakrishna-sre"
    cost_center = "hcl-hackathon-dev"
    managed_by  = "terraform"
  }
}

module "networking" {
  source = "../../modules/networking"

  project_id     = var.project_id
  project_prefix = var.project_prefix
  environment    = var.environment
  region         = var.region
  subnet_cidr    = var.subnet_cidr
}

module "iam" {
  source = "../../modules/iam"

  project_id     = var.project_id
  project_prefix = var.project_prefix
  environment    = var.environment
}

module "storage" {
  source = "../../modules/storage"

  project_id         = var.project_id
  project_prefix     = var.project_prefix
  environment        = var.environment
  location           = "US"
  force_destroy      = true
  lifecycle_age_days = 7
  labels             = local.mandatory_labels
}

module "compute" {
  source = "../../modules/compute"

  project_id            = var.project_id
  project_prefix        = var.project_prefix
  environment           = var.environment
  zone                  = var.zone
  machine_type          = var.machine_type
  subnet_self_link      = module.networking.subnet_self_link
  service_account_email = module.iam.service_account_email
  artifacts_bucket_name = module.storage.bucket_name
  enable_public_ip      = false
  labels                = local.mandatory_labels

  depends_on = [
    module.networking,
    module.iam,
    module.storage
  ]
}
