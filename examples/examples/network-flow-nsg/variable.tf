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

variable "address_prefixes" {
  type        = string
  description = "IP address range for subnet"
}

variable "subnet_name" {
  type        = string
  description = "New Subnet Name"
}

variable "virtual_network_name" {
  type        = string
  description = "Vnet name for new subnet"
}

variable "virtual_network_resource_group_name" {
  type        = string
  description = "Resource Group for Vnet"
}

variable "server_environment" {
  type        = string
  description = "Used to generate the name of servers based on the server-identification standard"
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
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "7-LVM"
    version   = "latest"
  }
}

variable "disk_os_size_linux" {
  description = "Size of linux os disk in GB"
  type        = string
  default     = "64"
}

variable "key_vault_name" {
  type        = string
  description = "Name of the key vault, used to retrieve VM admin password"
}

variable "key_vault_rg" {
  type        = string
  description = "Resource group that contains key vault"
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

variable "reporting_interval" {
  type        = string
  description = "Frequency of updates to logs. Acceptable values are 60 or 10 (minutes)"
  default     = "60"
}

variable "analytics" {
  type        = bool
  description = "Check whether the log analytics element of the flow logs is deployed"
  default     = true
}
