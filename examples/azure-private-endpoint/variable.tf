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
  description = "The target resource group this module should be deployed into. If not specified one will be created for you with name like: environment-application-template-location"
  default     = ""
}

variable "label" {
  type        = string
  description = "An optional label to distibuish multiple private endpoint instances defined in the same config"
  default     = ""
}

variable "private_connection_resource_id" {
  type        = string
  description = "The ID of the remote resource for the private endpoint"
}

variable "private_dns_zone_id" {
  type        = string
  description = "ID of the zone"
}

variable "subnet_name" {}
variable "virtual_network_name" {}
variable "virtual_network_resource_group_name" {}

variable "subresource_names" {
  type        = list(string)
  description = "A list (only one list item is allowed) containing the allowed subresource names a private endpoint connection may connect to eg \"blob\", \"sqlServer\", \"vault\" etc"
  default     = []
}