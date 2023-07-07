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

variable "integration_service_environment_id" {
  type        = string
  description = "The ID of the ISE to associate this Logic App to for VNet integration"
  default     = null
}

variable "logic_app_integration_account_id" {
  type        = string
  description = "ID of the integration account to be used for the ISE"
  default     = null
}

variable "workflow_parameters" {
  type        = map(string)
  description = "Key values of parameters to be supplied to the logic app"
  default     = null
}

variable "parameters" {
  type        = map(string)
  description = "Key values of parameters, note these ones must also exist in the workflow_parameters varaible"
  default     = null
}

variable "workflow_schema" {
  type        = string
  description = "Schema to use"
  default     = "https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#"
}