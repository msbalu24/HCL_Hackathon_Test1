output "service_account_email" {
  description = "Email address of the created application service account"
  value       = google_service_account.app_sa.email
}

output "service_account_id" {
  description = "Unique resource ID of the created application service account"
  value       = google_service_account.app_sa.id
}

output "service_account_member" {
  description = "IAM member string for the created service account"
  value       = "serviceAccount:${google_service_account.app_sa.email}"
}
