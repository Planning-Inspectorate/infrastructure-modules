# azure-monitor-logging

This directory contains code that is used to deploy Azure monitor log diagnostics to a specified resource.

Supported logging schemas can be found: https://docs.microsoft.com/en-us/azure/azure-monitor/essentials/resource-logs-schema#service-specific-schemas

## Example

The following provides an example of the call to this module, including the necessary variables with example values.
# The variable values can be set normally in a .tfvars file also if required

```
module "diagnostics" {
  source                     = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-monitor-logging?ref=1.0.0"
  target_resource_id         = var.target_resource_id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.law.id
}
```

## How To Update this README.md

* terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2, < 3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 2, < 3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_monitor_diagnostic_setting.diag](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_categories.catagories](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_diagnostic_setting_name"></a> [diagnostic\_setting\_name](#input\_diagnostic\_setting\_name) | Name of the diagnostic setting to be applied | `string` | `"audits-allmetrics"` | no |
| <a name="input_exclude_logging_catagories"></a> [exclude\_logging\_catagories](#input\_exclude\_logging\_catagories) | Log catagories which should not be configured | `list(string)` | `[]` | no |
| <a name="input_exclude_metric_catagories"></a> [exclude\_metric\_catagories](#input\_exclude\_metric\_catagories) | Metric catagories which should not be configured | `list(string)` | `[]` | no |
| <a name="input_log_analytics_destination_type"></a> [log\_analytics\_destination\_type](#input\_log\_analytics\_destination\_type) | Specifies if the logs sent to a Log Analytics workspace will go into resource specific tables or the legacy AzureDiagnostics table.  Possible values are Dedicated and AzureDiagnostics | `string` | `"AzureDiagnostics"` | no |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | The log analytics workspace ID to stream to | `string` | n/a | yes |
| <a name="input_retention_policy"></a> [retention\_policy](#input\_retention\_policy) | The retention policy of logs and metrics. Days set to 0 will keep them forever | `map(string)` | <pre>{<br>  "days": "93",<br>  "enabled": "true"<br>}</pre> | no |
| <a name="input_target_resource_id"></a> [target\_resource\_id](#input\_target\_resource\_id) | The target resource ID to which diagnostics logging will be applied | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_diagnostics_setting_id"></a> [diagnostics\_setting\_id](#output\_diagnostics\_setting\_id) | The ID of the created diagnostic setting |
| <a name="output_log_monitoring_catagories"></a> [log\_monitoring\_catagories](#output\_log\_monitoring\_catagories) | The available catagories that can be logged for the provided resource |
