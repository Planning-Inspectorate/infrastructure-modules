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

variable "business" {
  type        = string
  description = "Business unit which owns the infrastructure"
}

variable "service" {
  type        = string
  description = "Type of  infrastructure"
}

variable "vm_size" {
  type        = string
  description = "The size of VM ot provision"
}

variable "source_image_reference" {
  type = map(string)
  default = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

variable "key_vault_name" {
  type        = string
  description = "Name of the key vault, used to retrieve VM admin password"
}

variable "key_vault_rg" {
  type        = string
  description = "Resource group that contains key vault"
}

variable "patching" {
  type        = string
  default     = "0"
  description = "Allocates VM to Ivanti Patch Group"
}

variable "subnet_name_dr" {
  description = "Name of the subnet to be used in DR"
}

variable "vnet_resource_group_name_dr" {
  description = "Name of resource group containing vnet to be used in DR"
}

variable "vnet_name_dr" {
  description = "Name of vnet to be used in DR"
}

variable "asr_vault_name" {
  type        = string
  description = "Name of the ASR Vault to deploy replicated VM in to"
}

variable "asr_vault_rg" {
  type        = string
  description = "The resource group containing the Site Recovery vault to be used for VM replication"
}

variable "asr_primary_fabric_name" {
  type        = string
  description = "Name of the primary ASR fabric to use with replicated VM"
}

variable "asr_secondary_fabric_name" {
  type        = string
  description = "Name of the secondary ASR fabric to use with replicated VM"
}

variable "asr_primary_protection_container_name" {
  type        = string
  description = "Name of the primary ASR protection container to use with replicated VM"
}

variable "asr_secondary_protection_container_name" {
  type        = string
  description = "Name of the secondary ASR protection container to use with replicated VM"
}

variable "asr_policy_name" {
  type        = string
  description = "Name of the ASR policy to use with replicated VM"
}

variable "storage_replication" {
  type        = string
  description = "Storage account replication mode"
}

variable "network_rule_virtual_network_subnet_ids" {
  type        = list(string)
  description = "Subnets with access to the storage account"
  default = [
    "/subscriptions/bab9ed05-2c6e-4631-a0cf-7373c33838cc/resourceGroups/ExpressRoute-RG-TC1-01/providers/Microsoft.Network/virtualNetworks/Core-VN-01/subnets/bam-sn-01",
    "/subscriptions/bab9ed05-2c6e-4631-a0cf-7373c33838cc/resourceGroups/ExpressRoute-RG-TC1-01/providers/Microsoft.Network/virtualNetworks/Core-VN-01/subnets/vm-sn-01",
    "/subscriptions/c3dbe116-7ab5-4155-89c0-a81dcd9bfe9e/resourceGroups/production-its-subscription-northeurope/providers/Microsoft.Network/virtualNetworks/production-its-vnet-northeurope/subnets/production-itsaks-aks"
  ]
}

variable "network_rule_bypass" {
  type        = list(string)
  description = "Azure services with access to the storage account. Valid options are any combination of Logging, Metrics, AzureServices, or None"
  default = [
    "AzureServices"
  ]
}