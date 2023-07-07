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

variable "storage_account_id" {
  type        = string
  description = "Name of the storage account for storing logs"
}

variable "synapse_name" {
  type        = string
  description = "Name of the Synapse workspace"
  default     = ""
}

variable "public_network_access_enabled" {
  type        = string
  description = "Toggles public network access for Synapse Workspace (defaults to disabled, but needs to be enabled if there is no public endpoint and firewall rules need to be set)"
  default     = "false"
}

variable "synapse_dlg2fs_name" {
  type        = string
  description = "Name of the Synapse Workspace primary data lake gen2 filesystem"
  default     = ""
}

variable "sql_administrator_password" {
  description = "The password of the login for the SQL server administrator"
  default     = ""
  sensitive   = true
}

variable "sqlpools" {
  type        = list(map(string))
  description = <<-EOT
  "List of maps detailing Synapse SQL Pools with the following structure (collation defaults to SQL_LATIN1_GENERAL_CP1_CI_AS if not set):
  [
    {
      name          = "examplepool"
      pool_sku_name = "DW100c"
      collation     = "SQL_LATIN1_GENERAL_CP1_CI_AS"
    }
  ]"
  EOT
  default     = []
}

variable "synrbacroles" {
  type        = list(map(string))
  description = <<-EOT
  "List of maps detailing Syanpse RBAC Roles:
  [
    {
      role_name    = "Synapse Contributor"
      principal_id = xxx-xxx-xxx
    }
  ]"
  EOT
  default     = []
}

variable "fwrule_include_sharedBuildAgents" {
  type        = bool
  description = "A boolean switch to allow for scenarios where the default set of shared cicd subnets (containing Bamboo/ADO agents) should not be added to the Synapse Workspace firewall rules"
  default     = true
}

variable "fwrules" {
  type        = list(map(string))
  description = <<-EOT
  "List of maps detailing Synapse firewall rules with the following structure):
  [
    {
      name             = "examplepool"
      start_ip_address = "0.0.0.0"
      end_ip_address   = "0.0.0.0"
    }
  ]"
  EOT
  default     = []
}

variable "aad_admin_group" {
  description = "The Azure AD Admin group for the Synapse Workspace"
  default     = ""
}

variable "aad_admin_user" {
  description = "The Azure AD Admin user for the Synapse Workspace"
  default     = ""
}
