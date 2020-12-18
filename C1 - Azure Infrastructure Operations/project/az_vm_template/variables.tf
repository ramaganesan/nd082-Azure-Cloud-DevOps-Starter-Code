variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
}

variable "environment" {
    description = "Please provide environment tag name"
}

variable "project" {
    description = "Please provide project tag name"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  default = "eastus"
}

variable "vmcount" {
  description = "Please provide number of back end servers to configure"
}

variable "adminusername" {
  description = "Please provide admin username for VMS"
}

variable "adminpassword" {
  description = "Please provide admin password for VMS"
}

variable "packerimagename" {
  description = "Please provide valid Image name from the same RG as VM's"
}

variable "packerimagerg" {
  description = "Please provide valid RG for Packer Image"
}

variable "debugon" {
  description = "Please confirm if we need run the script in Debug mode, so debug on VM"
}