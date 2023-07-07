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
  description = "The name of the resource group which contains your target vnet for building a subnetand PE"
}

variable "virtual_network_name" {
  type        = string
  description = "The name of your virtual network where you'd like your new subnet and PE"
}

variable "address_prefixes_outbound" {
  type        = list(string)
  description = "The address range of subnet for outbound logic app connectivity"
}

variable "nsg_in_rules" {
  description = "A Map of inbound NSG rules"
  default     = {}
}

variable "nsg_out_rules" {
  description = "A Map of outound NSG rules"
  default     = {}
}

variable "law_resource_group_name" {
  type        = string
  description = "The name of the resource group containing your log analytics workspace"
}

variable "law_name" {
  type        = string
  description = "The name of your log analytics workspace"
}