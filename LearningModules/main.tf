terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.60.0"
    }
  }
}
provider "google"{
  credentials = file("hp-lbg-test-prj-12345-75418acabf8e.json")
}

resource "google_project" "my_project" {
  name = "hp-lbg-test-prj-${random_string.suffix.result}"
  project_id = var.project_id
  billing_account = var.billing_account
}

/*resource "google_project_service" "gcp_services" {
  for_each = toset(var.gcp_service_list)
  project = var.project_id
  service = each.key
}*/


resource "google_compute_network" "vpc_network" {
  project                 = var.project_id
  name                    = "my-auto-mode-network"
  auto_create_subnetworks = true
  mtu                     = 1460
}

resource "google_compute_firewall" "default_fw" {
  project = var.project_id
  name    = var.fw_name
  source_ranges = [
    "0.0.0.0/0"
  ]
  network = google_compute_network.vpc_network.self_link
  allow {
    protocol = "tcp"
    ports    = ["3389","22"]
  }

  allow {
    protocol = "icmp"
  }
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}
