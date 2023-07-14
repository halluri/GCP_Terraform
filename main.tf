# Terraform provider for GCP
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.60.0"
    }
  }
}
provider "google"{
  credentials = file("terraform-learning-391810-751efa905b1f.json")
  project = "terraform-learning-391810"
  region  = var.region
  zone    = var.zone
}


# To provision a vpc
resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}


# To create a private bucket in cloud storage 
resource "google_storage_bucket" "hp_private_bucket" {
  name     = "hp-private-bucket"
  location = var.region
  force_destroy = true
  public_access_prevention = "enforced"
  retention_policy{
    retention_period = 30
  }
}

# To put an object in bucket
resource "google_storage_bucket_object" "Warner-ICC-Centuries" {
  name   = "Warner-ICC-Centuries.csv"
  bucket = google_storage_bucket.hp_private_bucket.name
  source = "./Warner-ICC-Centuries.csv"
  depends_on = [google_storage_bucket.hp_private_bucket]
}

# To enable a dataset in BigQuery
resource "google_bigquery_dataset" "hp_dataset" {
  dataset_id                      = "hp_dataset"
  description                     = "creating an empty dataset in my project"
  location                        = var.region

}

# To populate a table in BQ_dataset
resource "google_bigquery_table" "Warner-ICC-Centuries" {
  dataset_id  = google_bigquery_dataset.hp_dataset.dataset_id
  table_id    = "Warner-ICC-Centuries"
  description = "All ICC Centuries of David Warner"
  deletion_protection=false

  schema = file("Warner-ICC-Centuries.json")

  external_data_configuration {
    autodetect    = false
    source_uris   = ["gs://${google_storage_bucket.hp_private_bucket.name}/Warner-ICC-Centuries.csv"]
    source_format = "CSV"

    /*hive_partitioning_options {
      mode = "AUTO"
      source_uri_prefix = "gs://${google_storage_bucket.hp_private_bucket.name}"
    }*/
  }

  depends_on = [google_bigquery_dataset.hp_dataset,
                google_storage_bucket_object.Warner-ICC-Centuries]
}


# To provide user managed Vertex AI notebook
resource "google_project_service" "notebooks" {
  provider           = google
  service            = "notebooks.googleapis.com"
  disable_on_destroy = false
}

resource "google_notebooks_instance" "basic_instance" {
  project      = "terraform-learning-391810"
  name         = "notebooks-instance-basic"
  provider     = google
  location     = "europe-west2-a"
  machine_type = "e2-medium"

  vm_image {
    project      = "deeplearning-platform-release"
    image_family = "tf-ent-2-9-cu113-notebooks"
  }

  depends_on = [
    google_project_service.notebooks
  ]
}


# To enable a central backend for terraform state file
terraform {
  backend "gcs" {
    bucket = "terraformbackendbucket"
    prefix = "terraform1"
    credentials = "terraform-learning-391810-751efa905b1f.json"
    
   }
} 
