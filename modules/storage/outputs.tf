output "bucket_name" {
  description = "The globally unique name of the created GCS bucket"
  value       = google_storage_bucket.artifacts.name
}

output "bucket_url" {
  description = "The base gs:// URL of the created GCS bucket"
  value       = google_storage_bucket.artifacts.url
}

output "bucket_self_link" {
  description = "The URI of the created GCS bucket"
  value       = google_storage_bucket.artifacts.self_link
}
