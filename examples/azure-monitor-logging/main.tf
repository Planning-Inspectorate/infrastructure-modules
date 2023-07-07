/**
* # azure-monitor-logging
* 
* This directory contains code that is used to deploy Azure monitor log diagnostics to a specified resource.
*
* Supported logging schemas can be found: https://docs.microsoft.com/en-us/azure/azure-monitor/essentials/resource-logs-schema#service-specific-schemas
*
* ## Example
* 
* The following provides an example of the call to this module, including the necessary variables with example values.
* # The variable values can be set normally in a .tfvars file also if required
* 
* ```
* module "diagnostics" {
*   source                     = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-monitor-logging?ref=1.0.0"
*   target_resource_id         = var.target_resource_id
*   log_analytics_workspace_id = data.azurerm_log_analytics_workspace.law.id
* }
* ```
* 
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

resource "azurerm_monitor_diagnostic_setting" "diag" {
  name                           = var.diagnostic_setting_name
  target_resource_id             = var.target_resource_id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  log_analytics_destination_type = var.log_analytics_destination_type

  dynamic "log" {
    for_each = local.logging_catagories

    content {
      category = log.key
      enabled  = true
      retention_policy {
        enabled = var.retention_policy.enabled
        days    = var.retention_policy.days
      }
    }
  }

  dynamic "metric" {
    for_each = local.metric_catagories

    content {
      category = metric.key
      enabled  = true
      retention_policy {
        enabled = var.retention_policy.enabled
        days    = var.retention_policy.days
      }
    }
  }
}