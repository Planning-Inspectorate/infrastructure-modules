/*
    Terraform configuration file defining variables
*/
variable "location" {
  type        = string
  description = "The region resources will be deployed to"
  default     = "northeurope"
}

variable "resource_group_name" {
  type        = string
  description = "The resource group of you Log Analytics workspace"
}

variable "workspace_id" {
  type        = string
  description = "The ID of the log analytics workspace"
}

variable "action_group_id" {
  type    = string
  default = "ID of the action group that alerts will trigger"
}

variable "user_defined_alerts" {
  type        = list(map(any))
  description = "User defined alerts that are joined to the baseline alerts"
  default     = []
}

variable "override_alerts" {
  type        = list(map(any))
  description = "Substitute the baseline alerts with this list of alerts instead"
  default     = []
}