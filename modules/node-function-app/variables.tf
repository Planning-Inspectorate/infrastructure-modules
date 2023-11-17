variable "action_group_low_id" {
  description = "The ID of the Azure Monitor action group for low priority alerts"
  type        = string
}

variable "app_name" {
  description = "The name of the function app"
  type        = string
}

variable "app_service_plan_id" {
  description = "The id of the app service plan"
  type        = string
}

variable "app_settings" {
  description = "The environment variables to be passed to the application"
  type        = map(string)
  default     = {}
}

variable "connection_strings" {
  description = "The connection strings to add to this Function App"
  type        = list(map(string))
  default     = []
}

variable "function_apps_storage_account" {
  description = "The name of the storage account used by the Function Apps"
  type        = string
}

variable "function_apps_storage_account_access_key" {
  description = "The access key for the storage account"
  type        = string
  sensitive   = true
}

variable "function_node_version" {
  default     = 14
  description = "Node version for function"
  type        = number
}

variable "inbound_vnet_connectivity" {
  default     = false
  description = "Indicates whether inbound connectivity (Private Endpoint) is required"
  type        = bool
}

variable "integration_subnet_id" {
  default     = null
  description = "The id of the vnet integration subnet the app service is linked to for egress traffic"
  type        = string
}

variable "key_vault_id" {
  description = "The ID of the key vault so the App Service can pull secret values"
  type        = string
  default     = null
}

variable "location" {
  description = "The name of the app service location"
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Azure Monitor Log Analytics Workspace"
  type        = string
}

variable "monitoring_alerts_enabled" {
  default     = false
  description = "Indicates whether Azure Monitor alerts are enabled for App Service"
  type        = bool
}

variable "outbound_vnet_connectivity" {
  default     = false
  description = "Indicates whether outbound connectivity (VNET Integration) is required"
  type        = bool
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "resource_suffix" {
  description = "The suffix for resource naming"
  type        = string
}

variable "service_name" {
  description = "The name of the service the app belongs to"
  type        = string
}

variable "tags" {
  description = "The tags applied to all resources"
  type        = map(string)
}

variable "use_app_insights" {
  description = "Decides if monitoring should be enabled"
  type        = bool
  default     = false
}
