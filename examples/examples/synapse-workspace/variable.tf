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

variable "synapse_dlg2fs_name" {
  description = "Name of the Synapse Workspace primary data lake gen2 filesystem (This is a pre-requestite of a Synapase Workspace and will be created by the module if not suplied)"
}

variable "aad_admin_user" {
  description = "The Azure AD Admin user for the Synapse Workspace"
}

variable "sqlpools" {
  type        = list(map(string))
  description = "map of Synapse SQL Pools"
}

variable "dlg2fs" {
  type        = list(string)
  description = "List of names of additional data lake gen2 filesystem to be created in storage account"
}
