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

variable "sql_password" {
  description = "Password for the SQL admin user"
  sensitive   = true
}

variable "vnet_resource_group" {
  description = "The resource group that contains the Virtual Network"
}

variable "vnet_name" {
  description = "The Virtual Network that contains the SQL MI specific subnet"
}

variable "subnet_name" {
  description = "The name of the dedicated SQLMI subnet"
}

variable "sku_name" {
  description = "Name of the Sku"
  default     = "GP_Gen5"
}

variable "sku_edition" {
  description = "Use case"
  default     = "GeneralPurpose"
}

variable "storage_size" {
  description = "Storage avaialble to this instance"
  default     = "32"
}

variable "cores" {
  description = "Number of vCores available to this instance"
  default     = "16"
}

variable "license" {
  description = "Type, can be either: LicenseIncluded, BasePrice"
  default     = "LicenseIncluded"
}

variable "hardware_family" {
  description = "Hardware family for underlying server VM"
  default     = "Gen5"
}


