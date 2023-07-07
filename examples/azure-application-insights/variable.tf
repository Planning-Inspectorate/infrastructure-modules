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

variable "application_type" {
  type        = string
  description = "Specifies the type of Application Insights to create. Valid values are ios for iOS, java for Java web, MobileCenter for App Center, Node.JS for Node.js, other for General, phone for Windows Phone, store for Windows Store and web for ASP.NET. Please note these values are case sensitive; unmatched values are treated as ASP.NET by Azure."
}

variable "daily_data_cap_in_gb" {
  type        = number
  description = "Daily data volume cap in Gb"
  default     = 1
}

variable "daily_data_cap_notifications_disabled" {
  type        = bool
  description = "Specifies if a notification email will be send when the daily data volume cap is met"
  default     = false
}

variable "retention_in_days" {
  type        = number
  description = "Data rentention period in days. Possible values are 30, 60, 90, 120, 180, 270, 365, 550 or 730"
  default     = 90
}

variable "sampling_percentage" {
  type        = number
  description = "Specifies the percentage of the data produced by the monitored application that is sampled for Application Insights telemetry"
  default     = null
}

variable "disable_ip_masking" {
  type        = bool
  description = "By default the real client ip is masked as 0.0.0.0 in the logs. Use this argument to disable masking and log the real client ip"
  default     = false
}

variable "workspace_id" {
  type        = string
  description = "The ID of a Log Analytics Workspace"
  default     = null
}