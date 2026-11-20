output "prod_vpc_name" {
  description = "Provisioned Prod VPC name"
  value       = module.networking.vpc_name
}

output "prod_app_service_account" {
  description = "Provisioned Prod application service account email"
  value       = module.iam.service_account_email
}

output "prod_artifacts_bucket" {
  description = "Provisioned Prod GCS bucket name"
  value       = module.storage.bucket_name
}

output "prod_vm_name" {
  description = "Provisioned Prod GCE instance name"
  value       = module.compute.instance_name
}

output "prod_vm_private_ip" {
  description = "Internal private IP of the Prod GCE instance"
  value       = module.compute.private_ip
}
