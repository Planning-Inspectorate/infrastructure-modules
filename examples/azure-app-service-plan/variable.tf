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

variable "kind" {
  type        = string
  description = "Kind of app service plan, Wndows, Linux or elastic"
  default     = "Linux"
}

variable "elastic_worker_count" {
  type        = string
  description = "Maximum number of workers for an Elastic sclaed App Service Plan"
  default     = null
}

variable "reserved" {
  type        = bool
  description = "Is this app service plan reserved, must be true for 'Kind' Linux and false for Windows/App"
  default     = true
}

variable "sku" {
  type        = map(string)
  description = "The Sku of the ASP"
  default = {
    tier     = "Standard"
    size     = "S1"
    capacity = "1"
  }
}

variable "app_service_env_id" {
  type        = string
  description = "ASE where the ASP should be located"
  default     = null
}

variable "site_scaling" {
  type        = bool
  description = "Can apps independently scale with this ASP?"
  default     = false
}