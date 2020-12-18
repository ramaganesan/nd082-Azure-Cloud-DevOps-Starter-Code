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

variable "loadbalancer" {
  type = any
}

variable "debugon" {
  type = number
}