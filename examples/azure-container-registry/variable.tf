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

variable "admin_enabled" {
  type        = string
  description = "Is the admin user enabled"
  default     = false
}

# variable "sku" {
#   type        = string
#   description = "Possible values are Basic, Standard and Premium"
#   default     = "Basic"
# }

variable "georeplication_locations" {
  type        = list(string)
  description = "List of Azure locations for geo-replication. Only permitted with Premium sku"
  default     = null
}

variable "default_action" {
  type        = string
  description = "Default access policy if a source doesn't match an IP rule or virtual network rule"
  default     = "Deny"
}

variable "ip_rules" {
  type        = list(map(string))
  description = <<-EOT
  "CIDRs and actions for network access i.e [{action = "Allow" ip_range = "127.0.0.1"}]
  EOT
  default     = []
}

variable "virtual_networks" {
  type        = list(map(string))
  description = <<-EOT
  "Subnet IDs and actions for network access i.e [{action = "Allow" subnet_id = guid}]
  EOT
  default     = []
}