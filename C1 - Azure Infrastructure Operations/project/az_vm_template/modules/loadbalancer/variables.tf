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

variable "networking" {
  type = any
}

variable "application_port" {
  type = number
  default = 80
}
