output "dev_vpc_name" {
  description = "Provisioned Dev VPC name"
  value       = module.networking.vpc_name
}

output "dev_app_service_account" {
  description = "Provisioned Dev application service account email"
  value       = module.iam.service_account_email
}

output "dev_artifacts_bucket" {
  description = "Provisioned Dev GCS bucket name"
  value       = module.storage.bucket_name
}

output "dev_vm_name" {
  description = "Provisioned Dev GCE instance name"
  value       = module.compute.instance_name
}

output "dev_vm_private_ip" {
  description = "Internal private IP of the Dev GCE instance"
  value       = module.compute.private_ip
}
