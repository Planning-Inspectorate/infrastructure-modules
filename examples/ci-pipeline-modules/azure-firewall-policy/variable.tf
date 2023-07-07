/*
    Terraform configuration file defining variables
*/
variable "environment" {
  type        = string
  description = "The environment name. Used as a tag and in naming the resource group"
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

variable "vnet_rg" {
  type        = string
  description = "The resource group that holds the vnet"
}

variable "application_rules" {
  description = "Complex map of application based rules"
}

variable "network_rules" {
  description = "Complex map of network based rules"
}

variable "nat_rules" {
  description = "Complex map of nat based rules. Note: if invalid attachment to firewall will fail"
}