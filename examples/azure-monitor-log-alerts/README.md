# azure-monitor-log-alerts

This directory contains code that is used to apply a set of log query alerts to a Log Analytics Workspace.

It comes with a set of baseline alerts which will be applied by default. You can add your own to this set with the variable `user_defined_alerts` or alternatively override the baseline completely and supply your own through the variable `override_alerts`.

## How To Use

### Baseline deployment

```terraform
module "log_alerts" {
  source              = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-monitor-log-alerts"
  location            = "northeurope"
  resource_group_name = "rg"
  action_group_id     = "xxx-xxx-xxx"
  workspace_id        = "xxx-xxx-xxx"
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
| <a name="requirement_time"></a> [time](#requirement\_time) | >=0.7, < 1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 2, < 3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_monitor_scheduled_query_rules_alert.query](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_scheduled_query_rules_alert) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_action_group_id"></a> [action\_group\_id](#input\_action\_group\_id) | n/a | `string` | `"ID of the action group that alerts will trigger"` | no |
| <a name="input_location"></a> [location](#input\_location) | The region resources will be deployed to | `string` | `"northeurope"` | no |
| <a name="input_override_alerts"></a> [override\_alerts](#input\_override\_alerts) | Substitute the baseline alerts with this list of alerts instead | `list(map(any))` | `[]` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group of you Log Analytics workspace | `string` | n/a | yes |
| <a name="input_user_defined_alerts"></a> [user\_defined\_alerts](#input\_user\_defined\_alerts) | User defined alerts that are joined to the baseline alerts | `list(map(any))` | `[]` | no |
| <a name="input_workspace_id"></a> [workspace\_id](#input\_workspace\_id) | The ID of the log analytics workspace | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ids"></a> [ids](#output\_ids) | List of IDs of the scheduled query alerts |
