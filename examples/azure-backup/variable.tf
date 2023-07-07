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

variable "vault_resource_group_name" {
  type        = string
  description = "The resource group containing the recovery services vault"
}

variable "recovery_vault_name" {
  type        = string
  description = "The recovery vault to be used for backups"
}

variable "storage_account_name" {
  type        = string
  description = "The storage account name which contains files to be backed up"
}

variable "storage_account_rg" {
  type        = string
  description = "The RG containing the storage account which contains files to be backed up"
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
  default     = 0
}

variable "weekly_backup_weekdays" {
  type        = list(string)
  description = "The weekday backups to retain. Must be one or more of Monday, Tuesday, Wednesday, Thursday, Friday, Saturday or Sunday"
  default     = []
}

variable "monthly_backup_retention" {
  type        = number
  description = "The number of monthly backups to keep. Between 1 - 200."
  default     = 0
}

variable "monthly_backup_weekdays" {
  type        = list(string)
  description = "The weekday backups to retain in the monthlies. Must be one or more of Monday, Tuesday, Wednesday, Thursday, Friday, Saturday or Sunday"
  default     = []
}

variable "monthly_backup_weeks" {
  type        = list(string)
  description = "The weekly backups to retain in the monthlies. Must be one or more of First, Second, Third, Fourth, Last"
  default     = []
}

variable "yearly_backup_retention" {
  type        = number
  description = "The number of yearly backups to keep. Between 1 - 10."
  default     = 0
}

variable "yearly_backup_weekdays" {
  type        = list(string)
  description = "The weekday backups to retain in the yearly. Must be one or more of Monday, Tuesday, Wednesday, Thursday, Friday, Saturday or Sunday"
  default     = []
}

variable "yearly_backup_weeks" {
  type        = list(string)
  description = "The weekly backups to retain in the yearly. Must be one or more of First, Second, Third, Fourth, Last"
  default     = []
}

variable "yearly_backup_months" {
  type        = list(string)
  description = "The monthly backups to retain in the yearly. Must be one or more of January, February, March, April, May, June, July, Augest, September, October, November and December"
  default     = []
}

variable "file_share_name" {
  type        = set(string)
  description = "List of file share names to include in backups"
  default     = []
}

variable "backup_timezone" {
  type        = string
  description = "Sets the timezone for the backup schedule. Accepts any timezone by name that Azure supports (documented here: https://dev.azure.com/hiscox/gp-psg/_wiki/wikis/PSG.wiki/350/Azure-Timezones)"
  default     = "UTC"
}