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

variable "subnet_name" {
  type        = string
  description = "The name of the subnet to create"
}

variable "vnet_resource_group_name" {
  type        = string
  description = "The resource group that contians the vnet"
}

variable "virtual_network_name" {
  type        = string
  description = "The name of the vnet resources will be deployed to"
}

variable "address_prefixes" {
  type        = list(string)
  description = "The address prefix for the subnet"
}

variable "service_endpoints" {
  description = "List of Service endpoints to associate with the subnet. Possible values include: Microsoft.AzureActiveDirectory, Microsoft.AzureCosmosDB, Microsoft.ContainerRegistry, Microsoft.EventHub, Microsoft.KeyVault, Microsoft.ServiceBus, Microsoft.Sql, Microsoft.Storage and Microsoft.Web"
  type        = list(string)
  default     = []
}

