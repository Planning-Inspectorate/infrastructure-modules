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

variable "data_factory_name" {
  type        = string
  description = "The data factory to deploy the SHIR into"
  default     = ""
}

variable "data_factory_resource_group_name" {
  type        = string
  description = "The resource group of the data factory to deploy the SHIR into"
  default     = ""
}

variable "linked_shir" {
  # type = object(
  #   {
  #     name                             = string,
  #     data_factory_name                = string,
  #     data_factory_resource_group_name = string
  #   }
  # )
  type        = map(string)
  description = "The details of a shared SHIR from another ADF instance to be linked to this new SHIR"
  default     = {}
}

variable "shir_name" {
  type        = string
  default     = ""
  description = "The name used for the SHIR in the Azure Data Factory"
}