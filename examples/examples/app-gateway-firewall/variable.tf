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

variable "vnet_resource_group_name" {
  type        = string
  description = "The resource group that contains to target virtual network"
}

variable "vnet_name" {
  type        = string
  description = "The name of the target virtual netowrk"
}

variable "subnet_name" {
  type        = string
  description = "The name of the subnet to create"
}

variable "address_prefixes" {
  type        = list(string)
  description = "The address range of the subnet to create"
}

variable "nsg_in_rules" {
  description = "Map on Inbound NSG rules"
}

variable "nsg_out_rules" {
  description = "Map on Outbound NSG rules"
}