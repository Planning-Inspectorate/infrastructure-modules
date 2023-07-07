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

variable "defender_plans" {
  type        = map(string)
  description = "Map of Defender for Cloud workload protection plans to enable. Key is the workload protection plan, value is the pricing tier to use. Possible values are Free and Standard"
  default = {
    AppServices                   = "Standard"
    Arm                           = "Standard"
    Containers                    = "Standard"
    Dns                           = "Standard"
    KeyVaults                     = "Standard"
    OpenSourceRelationalDatabases = "Standard"
    SqlServers                    = "Standard"
    SqlServerVirtualMachines      = "Standard"
    StorageAccounts               = "Standard"
    VirtualMachines               = "Standard"
  }
}

variable "enable_security_center_auto_provisioning" {
  description = "Setting to enable/ disable agent auto-provisioning on Virtual Machines in the subscription. Note that it is recommended not to use this feature in favour of using the Azure Monitor Agent with Data Collection Rules"
  default     = "Off"
}

variable "security_center_contacts" {
  type        = map(string)
  description = "Manages the subscription security contact"
  default     = {}
}

variable "enable_security_center_automation" {
  description = "Boolean flag to enable/ disable automation (Continuous Export)"
  default     = true
}

variable "mcas_setting" {
  description = "Allow Microsoft Defender for Cloud Apps to access my data"
  default     = true
}

variable "wdatp_setting" {
  description = "Allow Microsoft Defender for Endpoint to access my data"
  default     = true
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Log Analytics Workspace Resource ID"
  default     = "/subscriptions/bab9ed05-2c6e-4631-a0cf-7373c33838cc/resourceGroups/production-security-dfc-northeurope/providers/Microsoft.OperationalInsights/workspaces/production-security-logworkspace-northeurope"
}
