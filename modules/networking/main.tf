locals {
  vpc_name    = "${var.project_prefix}-${var.environment}-vpc"
  subnet_name = "${var.project_prefix}-${var.environment}-subnet-${var.region}"
}

resource "google_compute_network" "vpc" {
  name                            = local.vpc_name
  project                         = var.project_id
  auto_create_subnetworks         = false
  routing_mode                    = "REGIONAL"
  delete_default_routes_on_create = false
}

resource "google_compute_subnetwork" "subnet" {
  name                     = local.subnet_name
  project                  = var.project_id
  ip_cidr_range            = var.subnet_cidr
  region                   = var.region
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true

  lifecycle {
    create_before_destroy = true
  }
}

# Allow internal traffic only within the custom subnet CIDR
resource "google_compute_firewall" "allow_internal" {
  name    = "${local.vpc_name}-allow-internal"
  project = var.project_id
  network = google_compute_network.vpc.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  source_ranges = [var.subnet_cidr]
  priority      = 1000
}

# Enterprise Security Best Practice: Allow SSH only via Google IAP (no 0.0.0.0/0 exposure)
resource "google_compute_firewall" "allow_iap_ssh" {
  name    = "${local.vpc_name}-allow-iap-ssh"
  project = var.project_id
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["iap-ssh-allowed"]
  priority      = 1000
}
