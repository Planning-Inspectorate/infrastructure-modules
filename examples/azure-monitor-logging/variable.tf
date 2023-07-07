/*
    Terraform configuration file defining variables
*/

variable "log_analytics_workspace_id" {
  type        = string
  description = "The log analytics workspace ID to stream to"
}

variable "target_resource_id" {
  type        = string
  description = "The target resource ID to which diagnostics logging will be applied"
}

variable "retention_policy" {
  type        = map(string)
  description = "The retention policy of logs and metrics. Days set to 0 will keep them forever"
  default = {
    enabled = "true"
    days    = "93"
  }
}

variable "exclude_logging_catagories" {
  type        = list(string)
  description = "Log catagories which should not be configured"
  default     = []
}

variable "exclude_metric_catagories" {
  type        = list(string)
  description = "Metric catagories which should not be configured"
  default     = []
}

variable "log_analytics_destination_type" {
  type        = string
  description = "Specifies if the logs sent to a Log Analytics workspace will go into resource specific tables or the legacy AzureDiagnostics table.  Possible values are Dedicated and AzureDiagnostics "
  default     = "AzureDiagnostics"

}

variable "diagnostic_setting_name" {
  type        = string
  description = "Name of the diagnostic setting to be applied"
  default     = "audits-allmetrics"
}