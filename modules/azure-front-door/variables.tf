variable "cdn_frontdoor_origin_path" {
  description = "A directory path on the Front Door Origin that can be used to retrieve content"
  type        = string
}

variable "common_log_analytics_workspace_id" {
  description = "The ID for the common Log Analytics Workspace"
  type        = string
}

variable "common_tags" {
  description = "The common resource tags for the project"
  type        = map(string)
}

variable "forwarding_protocol" {
  description = "The forwarding protocol set for the cdn frontdoor route"
  type        = string
  default     = "MatchRequest"
}

variable "front_door_waf_mode" {
  description = "Indicates if the Web Application Firewall should be in Detection or Prevention mode"
  type        = string
  default     = "Detection"
}

variable "front_door_sku_name" {
  description = "The SKU name of the Front Door"
  type        = string
  default     = "Premium_AzureFrontDoor"
  validation {
    condition     = contains(["Standard_AzureFrontDoor", "Premium_AzureFrontDoor"], var.front_door_sku_name)
    error_message = "The SKU value must be Standard_AzureFrontDoor or Premium_AzureFrontDoor."
  }
}

variable "link_to_default_domain" {
  description = "Setting to select if this Front Door Route be linked to the default endpoint"
  type        = bool
  default     = true
}

variable "location" {
  description = "The location resources are deployed to in slug format e.g. 'uk-west'"
  type        = string
  default     = "uk-south"
}

variable "name" {
  description = "The name of the resource"
  type        = string
}
variable "host_name" {
  description = "The host name of the resource"
  type        = string
}

variable "https_redirect_enabled" {
  description = "Setting to select if this Front Door Route should automatically redirect HTTP traffic to HTTPS traffic"
  type        = bool
  default     = true
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "service_name" {
  description = "The name of the service the Front Door belongs to"
  type        = string
}

variable "session_affinity_enabled" {
  description = "The forwarding protocol set for the cdn frontdoor route"
  type        = bool
  default     = false
}
