# Node Function App

This Terraform module creates a Function App to deploy Azure functions.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.80.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_application_insights.function_app_insights](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) | resource |
| [azurerm_key_vault_access_policy.read_secrets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_linux_function_app.function_app](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_function_app) | resource |
| [azurerm_monitor_activity_log_alert.function_app_delete](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_activity_log_alert) | resource |
| [azurerm_monitor_activity_log_alert.function_app_stop](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_activity_log_alert) | resource |
| [azurerm_monitor_diagnostic_setting.function_app_logs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_metric_alert.function_app_http_5xx](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.function_app_response_time](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_action_group_low_id"></a> [action\_group\_low\_id](#input\_action\_group\_low\_id) | The ID of the Azure Monitor action group for low priority alerts | `string` | n/a | yes |
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | The name of the function app | `string` | n/a | yes |
| <a name="input_app_service_plan_id"></a> [app\_service\_plan\_id](#input\_app\_service\_plan\_id) | The id of the app service plan | `string` | n/a | yes |
| <a name="input_app_settings"></a> [app\_settings](#input\_app\_settings) | The environment variables to be passed to the application | `map(string)` | `{}` | no |
| <a name="input_connection_strings"></a> [connection\_strings](#input\_connection\_strings) | The connection strings to add to this Function App | `list(map(string))` | `[]` | no |
| <a name="input_function_apps_storage_account"></a> [function\_apps\_storage\_account](#input\_function\_apps\_storage\_account) | The name of the storage account used by the Function Apps | `string` | n/a | yes |
| <a name="input_function_apps_storage_account_access_key"></a> [function\_apps\_storage\_account\_access\_key](#input\_function\_apps\_storage\_account\_access\_key) | The access key for the storage account | `string` | n/a | yes |
| <a name="input_function_node_version"></a> [function\_node\_version](#input\_function\_node\_version) | Node version for function | `number` | `14` | no |
| <a name="input_integration_subnet_id"></a> [integration\_subnet\_id](#input\_integration\_subnet\_id) | The id of the vnet integration subnet the app service is linked to for egress traffic | `string` | `null` | no |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | The ID of the key vault so the App Service can pull secret values | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The name of the app service location | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | The ID of the Azure Monitor Log Analytics Workspace | `string` | n/a | yes |
| <a name="input_monitoring_alerts_enabled"></a> [monitoring\_alerts\_enabled](#input\_monitoring\_alerts\_enabled) | Indicates whether Azure Monitor alerts are enabled for App Service | `bool` | `false` | no |
| <a name="input_outbound_vnet_connectivity"></a> [outbound\_vnet\_connectivity](#input\_outbound\_vnet\_connectivity) | Indicates whether outbound connectivity (VNET Integration) is required | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group | `string` | n/a | yes |
| <a name="input_resource_suffix"></a> [resource\_suffix](#input\_resource\_suffix) | The suffix for resource naming | `string` | n/a | yes |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | The name of the service the app belongs to | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags applied to all resources | `map(string)` | n/a | yes |
| <a name="input_use_app_insights"></a> [use\_app\_insights](#input\_use\_app\_insights) | Decides if monitoring should be enabled | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_id"></a> [app\_id](#output\_app\_id) | The ID of the Function App |
| <a name="output_principal_id"></a> [principal\_id](#output\_principal\_id) | The ID of the principal associated with the Function App |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
