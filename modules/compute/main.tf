locals {
  instance_name = "${var.project_prefix}-${var.environment}-app-vm"

  common_labels = merge(
    {
      environment = var.environment
      managed_by  = "terraform"
      component   = "compute"
    },
    var.labels
  )
}

# Dynamic Data Source to fetch the latest hardened Debian 12 image
data "google_compute_image" "debian" {
  family  = "debian-12"
  project = "debian-cloud"
}

resource "google_compute_instance" "app_vm" {
  name         = local.instance_name
  project      = var.project_id
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["iap-ssh-allowed"]

  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = data.google_compute_image.debian.self_link
      size  = 20
      type  = "pd-standard"
    }
  }

  network_interface {
    subnetwork = var.subnet_self_link

    dynamic "access_config" {
      for_each = var.enable_public_ip ? [1] : []
      content {}
    }
  }

  service_account {
    email  = var.service_account_email
    scopes = ["cloud-platform"]
  }

  metadata = {
    enable-oslogin   = "TRUE"
    environment      = var.environment
    artifacts-bucket = var.artifacts_bucket_name
  }

  metadata_startup_script = <<-SCRIPT
    #!/bin/bash
    echo "HCL Enterprise Terraform IaC Demo - Environment: ${var.environment}" > /var/tmp/iac-status.txt
    echo "Artifacts Bucket: ${var.artifacts_bucket_name}" >> /var/tmp/iac-status.txt
  SCRIPT

  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  labels = local.common_labels

  lifecycle {
    ignore_changes = [
      metadata["ssh-keys"],
    ]
  }
}
