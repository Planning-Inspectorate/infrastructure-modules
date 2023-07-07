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

variable "dns_zones_subscription_id" {
  type        = string
  description = "The Azure subscription ID in which the private DNS zones to add the PE record(s) to reside"
  default     = "bab9ed05-2c6e-4631-a0cf-7373c33838cc"
}

variable "private_dns_zone_resource_group_name" {
  type        = string
  description = "The RG in the platform subscription that hosts the private DNS zones"
  default     = "prod-platform-privatedns-northeurope"
}