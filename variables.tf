#Variables file to define commonly used attributes across resources or modules

variable "project" {
  default = "terraform-learning-391810"
}

variable "region" {
  default = "us-central1" 
}

variable "zone"  {
  default = "us-central1-c"
}

variable "cidr_ip" {
  default = "10.0.0.0/16"
}