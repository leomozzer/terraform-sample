variable "subscription_id" {
  description = "Enter the subscription_id"
}

variable "client_id" {
  description = "Enter the client_id"
}

variable "client_secret" {
  description = "Enter the client_secret"
}

variable "tenant_id" {
  description = "Enter the tenant_id"
}

variable "publisher_email" {
  description = "Enter the publisher_email"
}

variable "location" {
  description = "Enter the location"
}

variable "resource_group" {
  description = "Enter the location"
  default = "sample-tf-rg"
}

variable "prod" {
  description = "Enter the stage"
  default = true
}

variable "newdisc" {
  description = "Add new disk"
  default = true
}

variable "prefix" {
  default = "sample-tf"
}