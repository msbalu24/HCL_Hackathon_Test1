output "vpc_id" {
  description = "The ID of the created VPC network"
  value       = google_compute_network.vpc.id
}

output "vpc_name" {
  description = "The name of the created VPC network"
  value       = google_compute_network.vpc.name
}

output "vpc_self_link" {
  description = "The URI of the created VPC network"
  value       = google_compute_network.vpc.self_link
}

output "subnet_id" {
  description = "The ID of the created subnetwork"
  value       = google_compute_subnetwork.subnet.id
}

output "subnet_self_link" {
  description = "The URI of the created subnetwork"
  value       = google_compute_subnetwork.subnet.self_link
}

output "subnet_cidr" {
  description = "The CIDR block of the created subnetwork"
  value       = google_compute_subnetwork.subnet.ip_cidr_range
}
