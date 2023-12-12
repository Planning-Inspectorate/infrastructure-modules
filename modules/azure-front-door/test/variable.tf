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

variable "host_name" {
  description = "The host name of the resource"
  type        = string
}

variable "name" {
  description = "The name of the resource"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "service_name" {
  description = "The name of the service the Front Door belongs to"
  type        = string
}

variable "tooling_subscription_id" {
  description = "The ID for the Tooling subscription that houses the Container Registry"
  type        = string
}
