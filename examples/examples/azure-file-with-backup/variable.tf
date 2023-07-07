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

variable "storage_replication" {
  type        = string
  description = "Storage account replication mode"
}

variable "access_tier" {
  type        = string
  description = "Storage account access tier"
}

variable "large_file_share_enabled" {
  type        = bool
  description = "Flag to determine if large file share is enabled on the storage account"
}

variable "shares" {
  type        = list(map(string))
  description = "List of map of the shares to create in the SA"
}

variable "network_rule_ips" {
  type        = list(string)
  description = "List of subnet IDs which are allowed to access the storage account"
}

variable "network_rule_bypass" {
  type        = list(string)
  description = "Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Valid options are any combination of Logging, Metrics, AzureServices, or None"
}

variable "backup_frequency" {
  type        = string
  description = "Sets the backup frequency. Currently only daily is supported"
  default     = "Daily"
}

variable "backup_time" {
  type        = string
  description = "The time of day to perform the backup in 24-hour format. Times must be either on the hour or half hour (e.g. 13:00 or 03:30)"
}

variable "daily_backup_retention" {
  type        = number
  description = "The number of daily backups to keep. Between 1 - 200."
}

variable "weekly_backup_retention" {
  type        = number
  description = "The number of weekly backups to keep. Between 1 - 200."
}

variable "weekly_backup_weekdays" {
  type        = list(string)
  description = "The weekday backups to retain. Must be one or more of Monday, Tuesday, Wednesday, Thursday, Friday, Saturday or Sunday"
}

variable "monthly_backup_retention" {
  type        = number
  description = "The number of monthly backups to keep. Between 1 - 200."
  default     = 0
}

variable "monthly_backup_weekdays" {
  type        = list(string)
  description = "The weekday backups to retain in the monthlies. Must be one or more of Monday, Tuesday, Wednesday, Thursday, Friday, Saturday or Sunday"
}

variable "monthly_backup_weeks" {
  type        = list(string)
  description = "The weekly backups to retain in the monthlies. Must be one or more of First, Second, Third, Fourth, Last"
  default     = []
}

variable "recovery_vault_name" {
  type        = string
  description = "The recovery vault to be used for backups"
}

variable "vault_resource_group_name" {
  type        = string
  description = "The resource group containing the recovery services vault"
}