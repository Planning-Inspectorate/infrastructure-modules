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