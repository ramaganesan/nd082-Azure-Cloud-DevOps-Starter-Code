variable "prefix" {
  type = string
}

variable "environment" {
    type = string
}

variable "project" {
    type = string
}

variable "location" {
  type = string
}

variable "vmcount" {
    type = number
}

variable "networking" {
  type = any
}

variable "vmconfig" {
  type = any
}

variable "packerimagename" {
  type = string
}

variable "packerimagerg" {
  type = string
}

variable "adminusername" {
  type = string
}

variable "adminpassword" {
  type = string
}