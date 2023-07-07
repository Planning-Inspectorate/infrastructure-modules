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

variable "nsg_in_rules" {
  description = "A Map of inbound NSG rules"
  default     = {}
}

variable "nsg_out_rules" {
  description = "A Map of outound NSG rules"
  default     = {}
}

variable "network_watcher_name" {
  type        = string
  description = "Name of network watcher"
}

variable "network_watcher_resource_group_name" {
  type        = string
  description = "Resource Group for network watcher"
}
