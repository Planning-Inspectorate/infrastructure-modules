/**
* # azure-monitor-metrics
* 
* This directory contains code that is used to deploy Azure monitor alert rules to a resource.
*
* The alerts are defined as baselines in `locals.tf` which will tell you what resource types are currently supported.
*
* ## Example
* 
* The following provides an example of the call to this module, including the necessary variables with example values.
* # The variable values can be set normally in a .tfvars file also if required
* 
* ```
* module "metrics" {
*   source                = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-monitor-metrics?ref=1.0.0"
*   target_resource_group = module.blah.resource_group_name
*   target_resource_name  = module.blah.name
*   target_resource_id    = module.blah.id
*   target_resource_type  = "Microsoft.Storage/storageAccounts" # adjust this based on your Azure resource
*   action_group_name_id  = data.azure_action_group.ag.id
* }
* ```
* 
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

resource "azurerm_monitor_metric_alert" "alert" {
  for_each            = local.alerts
  name                = join("-", [each.key, var.target_resource_name])
  resource_group_name = var.target_resource_group
  scopes              = [var.target_resource_id]
  description         = each.value.description

  criteria {
    metric_namespace = each.value.namespace
    metric_name      = each.value.metric_name
    aggregation      = each.value.aggregation
    operator         = each.value.operator
    threshold        = each.value.threshold

    dynamic "dimension" {
      for_each = [for d in split("::", each.value.dimensions) : zipmap(["name", "operator", "values"], split(",", d)) if length(d) > 1]
      content {
        name     = dimension.value.name
        operator = dimension.value.operator
        values   = [dimension.value.values]
      }
    }
  }

  action {
    action_group_id = var.action_group_id
  }

  frequency   = each.value.frequency
  severity    = each.value.severity
  window_size = each.value.window_size

  tags = local.tags
}