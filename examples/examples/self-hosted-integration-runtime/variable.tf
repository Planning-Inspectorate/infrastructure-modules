/*
    Terraform configuration file defining variables
*/
variable "environment" {
  type        = string
  description = "The environment name. Used as a tag and in naming the resource group"
}

variable "server_environment" {
  type        = string
  description = "Used to generate the name of servers based on the server-identification standard"
}

variable "application" {
  type        = string
  description = "Name of the application"
}


variable "location" {
  type        = string
  description = "The region resources will be deployed to"
  default     = "northeurope"
}

variable "tags" {
  type        = map(string)
  description = "List of tags to be applied to resources"
  default     = {}
}

variable "business" {}

variable "service" {}

variable "vm_count_windows" {}

variable "vm_size" {}

variable "admin_password" {}

variable "subnet_name" {}

variable "virtual_network_name" {}

variable "virtual_network_resource_group_name" {}

variable "shir_key_vault_name" {}

variable "shir_key_vault_resource_group_name" {}

variable "shir_certificate_name" {}

variable "shir_secret_name" {}

variable "shir_certificate_domain" {}

