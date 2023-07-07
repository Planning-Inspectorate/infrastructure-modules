# azure-monitor-metrics

This directory contains code that is used to deploy Azure monitor alert rules to a resource.

The alerts are defined as baselines in `locals.tf` which will tell you what resource types are currently supported.

## Example

The following provides an example of the call to this module, including the necessary variables with example values.
# The variable values can be set normally in a .tfvars file also if required

```
module "metrics" {
  source                = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-monitor-metrics?ref=1.0.0"
  target_resource_group = module.blah.resource_group_name
  target_resource_name  = module.blah.name
  target_resource_id    = module.blah.id
  target_resource_type  = "Microsoft.Storage/storageAccounts" # adjust this based on your Azure resource
  action_group_name_id  = data.azure_action_group.ag.id
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
| <a name="requirement_external"></a> [external](#requirement\_external) | >= 2, < 3 |
| <a name="requirement_template"></a> [template](#requirement\_template) | >= 2, < 3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 2, < 3 |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_monitor_metric_alert.alert](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [time_static.t](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_action_group_id"></a> [action\_group\_id](#input\_action\_group\_id) | The id of the action group to assign monitor triggers | `string` | n/a | yes |
| <a name="input_alert_definitions"></a> [alert\_definitions](#input\_alert\_definitions) | User-defined alert configurations to be merged with the default baseline | `list(map(string))` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map tags to be applied to resources | `map(string)` | `{}` | no |
| <a name="input_target_resource_group"></a> [target\_resource\_group](#input\_target\_resource\_group) | Resource group that holds the resource you want to monitor | `string` | n/a | yes |
| <a name="input_target_resource_id"></a> [target\_resource\_id](#input\_target\_resource\_id) | ID of the resource you want to monitor | `string` | n/a | yes |
| <a name="input_target_resource_name"></a> [target\_resource\_name](#input\_target\_resource\_name) | Name of the resouerce you want to monitor | `string` | n/a | yes |
| <a name="input_target_resource_type"></a> [target\_resource\_type](#input\_target\_resource\_type) | THe Azure type of the resource you want to monitor | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_metric_id"></a> [metric\_id](#output\_metric\_id) | List of IDs of the metric alert rules |
