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

variable "key_vault_name" {
  type        = string
  description = "Name of the key vault, used to retrieve VM admin password"
}

variable "key_vault_rg" {
  type        = string
  description = "Resource group that contains key vault"
}

variable "postgresqlflx_configuration" {
  type        = map(string)
  description = "List of configuration options to apply to database"
  default     = {}
}