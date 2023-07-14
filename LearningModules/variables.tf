variable "billing_account" {
  description = "The ID of the billing account to associate this project with"
  type        = string
  default = "01BC4F-17895B-EC0255"
}

variable "project_id" {
  default = "hp-lbg-test-prj-12345"
}

variable "gcp_service_list" {
  description ="The list of apis necessary for the project"
  type = list(string)
  default = [
    "compute.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com"    
  ]
}

variable "fw_name"{
  default="default-fw"
}
