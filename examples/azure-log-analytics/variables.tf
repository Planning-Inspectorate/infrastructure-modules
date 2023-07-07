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

variable "resource_group_name" {
  type        = string
  description = "The target resource group this module should be deployed into. If not specified one will be created for you with name like: environment-application-template-location"
  default     = ""
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "log_analytics_sku" {
  type        = string
  description = "Specifies the Sku of the Log Analytics Workspace, as of 2018-04-03 only PerGB2018 is accepted"
  default     = "PerGB2018"
}

variable "retention_days" {
  type        = number
  description = "Data retentions days, between 30 and 730."
  default     = 30
}

variable "export_rules" {
  type = map(object({
    dest_resource_id = string
    tables           = list(string)
    enabled          = bool
  }))
  description = <<-EOT
  "For exporting LAW tables to external resources. Outer map `keys` are the names of rules, e.g:
  rule-name = {
    dest_resource_id = "01234-56789"
    tables           = ["Heartbeat", "ActivityLog"]
    enabled          = true
  }"
  EOT
  default     = {}
}