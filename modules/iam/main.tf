locals {
  sa_account_id = "${var.project_prefix}-${var.environment}-app-sa"
}

resource "google_service_account" "app_sa" {
  account_id   = local.sa_account_id
  display_name = "HCL Terraform ${upper(var.environment)} Application Service Account"
  description  = "Least-privilege service account for ${var.environment} compute workloads"
  project      = var.project_id
}

resource "google_project_iam_member" "app_sa_roles" {
  for_each = toset(var.iam_roles)

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.app_sa.email}"
}
