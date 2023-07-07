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
  description = "Resource group name of the vnet"
}

variable "virtual_network_name" {
  description = "name of the vnet"
}

variable "service_endpoints" {
  description = "List of subnet service endpoints to enable"
  type        = list(any)
  default     = ["Microsoft.Storage", "Microsoft.Sql", "Microsoft.AzureActiveDirectory", "Microsoft.KeyVault", "Microsoft.AzureCosmosDB"]
}

variable "ssh_pub_key" {
  description = "Key for VM access. Never to be used"
}

variable "aks_in_rules" {
  description = "A Map of inbound NSG rules"
  default     = {}
}

variable "aks_out_rules" {
  description = "A Map of outound NSG rules"
  default     = {}
}

variable "address_prefixes" {
  type        = list(string)
  description = "Subnet range to be created"
}

variable "keyvault_ip_rules" {
  type        = list(string)
  description = "List of IPs allowed to access key vault"
}