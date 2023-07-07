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

variable "location_dr" {
  type        = string
  description = "The region resources will be deployed to"
  default     = "westeurope"
}

variable "tags" {
  type        = map(string)
  description = "List of tags to be applied to resources"
  default     = {}
}

variable "event_hubs" {
  type        = list(map(any))
  description = "A list of event hubs to be associated with the namespace. Each map must have a key called name"
  default     = []
}