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

variable "resource_group_name" {
  type        = string
  description = "The resource group to deploy the Azure Firewall into. It must also contain the vnet and subnet"
}

variable "sku_name" {
  type        = string
  description = "Possible values are AZFW_Hub and AZFW_VNet"
  default     = "AZFW_VNet"
}

variable "sku_tier" {
  type        = string
  description = "Tier of the firewall"
  default     = "Standard"
}

variable "subnet_id" {
  type        = string
  description = "The subnet ID from which the firewall will receive a private IP"
}

variable "firewall_policy_id" {
  type        = string
  description = "The ID of a firewall policy that should be attached to this firewall"
  default     = null
}