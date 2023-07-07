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

variable "flow_log_name" {
  type        = string
  description = "The name of the flow log"
}

variable "network_watcher_name" {
  type        = string
  description = "Name of the network watcher"
}

variable "network_watcher_resource_group_name" {
  type        = string
  description = "Resource Group of the network watcher"
}

variable "storage_account_id" {
  type        = string
  description = "Name of the storage account for storing logs"
}

variable "network_security_group_id" {
  type        = string
  description = "Name of the nsg where logs will be captured from"
}

variable "log_analytics_workspace_name" {
  type        = string
  description = "Name of the log analytics workspace"
}

variable "log_analytics_workspace_resource_group_name" {
  type        = string
  description = "Resource Group of the log analytics workspace"
}

variable "reporting_interval" {
  type        = string
  description = "Frequency of updates to logs. Acceptable values are 60 or 10 (minutes)"
  default     = "60"
}

variable "nsg_port" {
  type        = string
  description = "Frequency of updates to logs. Acceptable values are 60 or 10 (minutes)"
  default     = "60"
}

variable "analytics" {
  type        = bool
  description = "Check whether the log analytics element of the flow logs is deployed"
  default     = true
}

variable "retention_duration" {
  type        = string
  description = "duration to keep logs in storage account"
  default     = 2
}
