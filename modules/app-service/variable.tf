variable "app_name" {
  description = "The name of the app service"
  type        = string
}

variable "app_service_private_dns_zone_id" {
  description = "The id of the private DNS zone for App services"
  type        = string
  default     = null
}

variable "app_service_plan_id" {
  description = "The id of the app service plan"
  type        = string
}

variable "app_service_plan_resource_group_name" {
  description = "The App Service Plan resource group name required for custom hostname certificate placement"
  type        = string
  default     = null
}

variable "app_settings" {
  description = "The environment variables to be passed to the application"
  type        = map(string)
  default     = {}
}

variable "location" {
  description = "The name of the app service location"
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Azure Monitor Log Analytics Workspace"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "os_type" {
  description = "The OS type of the app service plan"
  type        = string
}

variable "sku_name" {
  description = "The name of the sku"
  type        = string
}


variable "tags" {
  description = "The tags applied to all resources"
  type        = map(string)
}
