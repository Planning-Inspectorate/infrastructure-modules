# azure-log-analytics

This directory stands up an Azure Log Analytics Workspace

## How To Use

```terraform
module "law" {
  source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-log-analytics"
  environment = "dev"
  application = "app"
  location    = "northeurope"
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
| <a name="provider_time"></a> [time](#provider\_time) | >=0.7, < 1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_log_analytics_data_export_rule.export](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_data_export_rule) | resource |
| [azurerm_log_analytics_workspace.log_analytics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [time_static.t](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Name of the application | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name. Used as a tag and in naming the resource group | `string` | n/a | yes |
| <a name="input_export_rules"></a> [export\_rules](#input\_export\_rules) | "For exporting LAW tables to external resources. Outer map `keys` are the names of rules, e.g:<br>rule-name = {<br>  dest\_resource\_id = "01234-56789"<br>  tables           = ["Heartbeat", "ActivityLog"]<br>  enabled          = true<br>}" | <pre>map(object({<br>    dest_resource_id = string<br>    tables           = list(string)<br>    enabled          = bool<br>  }))</pre> | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | The region resources will be deployed to | `string` | `"northeurope"` | no |
| <a name="input_log_analytics_sku"></a> [log\_analytics\_sku](#input\_log\_analytics\_sku) | Specifies the Sku of the Log Analytics Workspace, as of 2018-04-03 only PerGB2018 is accepted | `string` | `"PerGB2018"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The target resource group this module should be deployed into. If not specified one will be created for you with name like: environment-application-template-location | `string` | `""` | no |
| <a name="input_retention_days"></a> [retention\_days](#input\_retention\_days) | Data retentions days, between 30 and 730. | `number` | `30` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_location"></a> [location](#output\_location) | The location of the resource |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Name of the resource group where resources have been deployed to |
| <a name="output_workspace_customer_id"></a> [workspace\_customer\_id](#output\_workspace\_customer\_id) | Customer ID of the workspace |
| <a name="output_workspace_id"></a> [workspace\_id](#output\_workspace\_id) | The ID of the workspace |
| <a name="output_workspace_name"></a> [workspace\_name](#output\_workspace\_name) | The name of the workspace |
| <a name="output_workspace_primary_key"></a> [workspace\_primary\_key](#output\_workspace\_primary\_key) | Primary key of the workspace |
| <a name="output_workspace_secondary_key"></a> [workspace\_secondary\_key](#output\_workspace\_secondary\_key) | Secondary key of the workspace |
| <a name="output_workspace_url"></a> [workspace\_url](#output\_workspace\_url) | The portal URL of the workspace |
