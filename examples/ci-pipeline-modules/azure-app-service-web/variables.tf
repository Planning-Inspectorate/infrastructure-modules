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
  description = "List of tags to be applied to resources"
  type        = map(string)
  default     = {}
}

variable "site_config" {
  description = "Site config to override site_config_defaults. Object structure identical to site_config_defaults"
  default     = {}
}
