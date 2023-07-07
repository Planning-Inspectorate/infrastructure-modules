/**
* # azure-monitor-log-alerts
* 
* This directory contains code that is used to apply a set of log query alerts to a Log Analytics Workspace.
*
* It comes with a set of baseline alerts which will be applied by default. You can add your own to this set with the variable `user_defined_alerts` or alternatively override the baseline completely and supply your own through the variable `override_alerts`.
* 
* ## How To Use
*
* ### Baseline deployment
*
* ```terraform
* module "log_alerts" {
*   source              = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-monitor-log-alerts"
*   location            = "northeurope"
*   resource_group_name = "rg"
*   action_group_id     = "xxx-xxx-xxx"
*   workspace_id        = "xxx-xxx-xxx"
* }
* ```
* 
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

resource "azurerm_monitor_scheduled_query_rules_alert" "query" {
  for_each            = length(local.log_alerts_override) > 0 ? local.log_alerts_override : local.log_alerts
  name                = each.key
  location            = var.location
  resource_group_name = var.resource_group_name

  action {
    action_group = [var.action_group_id]
    # email_subject          = "Email Header"
    # custom_webhook_payload = "{}"
  }
  data_source_id = var.workspace_id
  description    = each.value.description
  enabled        = true
  query          = each.value.query
  severity       = each.value.severity    # 0, 1 ,2, 3, 4
  frequency      = each.value.frequency   # how frequently in minutes rule should be evalulated
  time_window    = each.value.time_window # time window of data, must be greater than frequency
  throttling     = each.value.throttling  # Time in minutes alerts should be suppressed for
  trigger {
    operator  = each.value.operator  # evaluation rule
    threshold = each.value.threshold # result or count to trigger rule
    # metric_trigger {
    #   operator            = "GreaterThan"
    #   threshold           = 1
    #   metric_trigger_type = "Total"
    #   metric_column       = "operation_Name"
    # }
  }
}