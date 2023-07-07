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
  description = "Tier of service bus"
  default     = "Standard"
}

variable "capacity" {
  type        = map(number)
  description = "Capacity size, must be 0 when sku is Standard, for Premium acceptable values are 1, 2, 4 or 8"

  default = {
    Basic    = 0
    Standard = 0
    Premium  = 4
  }
}

variable "network_rule_subnet_ids" {
  type        = list(string)
  description = "A list of subnet IDs which should be allowed access to the Service Bus namespace"
  default     = []
}

variable "network_rule_ips" {
  type        = list(string)
  description = "List of IP addresses or CIDR blocks which should be allowed access to the Service Bus namespace"
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
  default     = true
}

variable "namespace_authorization_rule_manage" {
  type        = bool
  description = "Grants manage access on the auth rule"
  default     = false
}

variable "queues" {
  type        = list(map(any))
  description = <<-EOT
  "List of queues, each map must contain a name field. Optional parameters that can be overriden (defaults can be found under locals.tf):
  {
    lock_duration
    max_size_in_megabytes
    requires_duplicate_detection
    requires_session
    auto_delete_on_idle
    default_message_ttl
    dead_lettering_on_message_expiration
    duplicate_detection_history_time_window
    max_delivery_count
    status
    enable_batched_operations
    listen
    send
    manage
  }"
  EOT
  default     = []
}

variable "topics" {
  type        = list(map(any))
  description = <<-EOT
  "List of topics, each map must contain a name field. Optional parameters that can be overriden (defaults can be found under locals.tf):
  {
    status
    auto_delete_on_idle
    default_message_ttl
    duplicate_detection_history_time_window
    enable_batched_operations
    enable_express
    max_size_in_megabytes
    requires_duplicate_detection
    support_ordering
  }"
  EOT
  default     = []
}
