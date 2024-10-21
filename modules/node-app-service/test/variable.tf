variable "action_group_ids" {
  description = "The IDs of the Azure Monitor action groups for different alert types"
  type = object({
    tech            = string,
    service_manager = string,
    iap             = string,
    its             = string,
    info_sec        = string
  })
}

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

variable "container_registry_name" {
  description = "The name of the container registry that hosts the image"
  type        = string
}

variable "container_registry_rg" {
  description = "The resource group of the container registry that hosts the image"
  type        = string
}

variable "custom_hostname" {
  description = "The custom hostname applied to the App Service required for auth redirection with a reverse proxy"
  type        = string
  default     = null
}

variable "custom_hostname_certificate_secret_id" {
  description = "The Key Vault secret URL for the custom hostname SSL certificate"
  type        = string
  default     = null
}

variable "endpoint_subnet_id" {
  default     = null
  description = "The id of the private endpoint subnet the app service is linked to for ingress traffic"
  type        = string
}

variable "health_check_path" {
  description = "The path of the service's health check endpoint"
  type        = string
  default     = null
}

variable "image_name" {
  description = "The name of the image deployed to the App Service"
  type        = string
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

variable "key_vault_id" {
  description = "The ID of the key vault so the App Service can pull secret values"
  type        = string
  default     = null
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

variable "tooling_subscription_id" {
  description = "The ID for the Tooling subscription that houses the Container Registry"
  type        = string
}
