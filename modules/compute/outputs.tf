output "instance_id" {
  description = "The server-assigned unique ID of the compute instance"
  value       = google_compute_instance.app_vm.instance_id
}

output "instance_name" {
  description = "The name of the created compute instance"
  value       = google_compute_instance.app_vm.name
}

output "instance_self_link" {
  description = "The URI of the created compute instance"
  value       = google_compute_instance.app_vm.self_link
}

output "private_ip" {
  description = "The internal private IP address assigned to the compute instance"
  value       = google_compute_instance.app_vm.network_interface[0].network_ip
}
