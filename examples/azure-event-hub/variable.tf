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

variable "sku" {
  type        = string
  description = "The Sku of the event hub namespace. Either Basic, Standard or Premium"
  default     = "Standard"
}

variable "namespace_capacity" {
  type        = number
  description = "Specifies the Capacity / Throughput Units for a Standard SKU namespace"
  default     = 2
}

variable "auto_inflate" {
  type        = bool
  description = "Auto scaling of namespace"
  default     = false
}

variable "max_throughput_units" {
  type        = number
  description = "If auto_inflate is true this specifies the maximum number of throughput units. Valid values between 1 and 20"
  default     = 2
}

variable "vnet_rules" {
  type        = list(string)
  description = "A list of subnet IDs which should be permitted access to the namespace"
  default     = []
}

variable "ip_rules" {
  type        = list(string)
  description = "A list of IP masks which source traffic should be permitted to access the namespace"
  default     = []
}

variable "namespace_authorization_rule_listen" {
  type        = bool
  description = "Grants listen access on the auth rule"
  default     = true
}

variable "namespace_authorization_rule_send" {
  type        = bool
  description = "Grants send access on the auth rule"
  default     = false
}

variable "namespace_authorization_rule_manage" {
  type        = bool
  description = "Grants manage access on the auth rule. Listen and send must both be true if this is set to true"
  default     = false
}

variable "event_hubs" {
  type        = list(map(any))
  description = "A list of event hubs to be associated with the namespace. Each map must have a key called name. Sensible defaults are merged into this in locals.tf which you can override in your map"
  default     = []
}

variable "capture_description" {
  type        = map(any)
  description = "Details of a storage account where data should be streamed to for long term storage"
  default     = null
}