locals {
  bucket_name = "${var.project_prefix}-${var.environment}-artifacts-${var.project_id}"

  common_labels = merge(
    {
      environment = var.environment
      managed_by  = "terraform"
      component   = "storage"
    },
    var.labels
  )
}

resource "google_storage_bucket" "artifacts" {
  name                        = local.bucket_name
  project                     = var.project_id
  location                    = var.location
  storage_class               = "STANDARD"
  force_destroy               = var.force_destroy
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      age = var.lifecycle_age_days
    }
    action {
      type = "Delete"
    }
  }

  labels = local.common_labels
}
