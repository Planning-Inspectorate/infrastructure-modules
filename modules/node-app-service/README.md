# Node App service

This Terraform module creates an App service to deploy backend or frontend services.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.94.0 |
| <a name="provider_azurerm.tooling"></a> [azurerm.tooling](#provider\_azurerm.tooling) | 3.94.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_app_service_certificate.custom_hostname](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_certificate) | resource |
| [azurerm_app_service_custom_hostname_binding.custom_hostname](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_custom_hostname_binding) | resource |
| [azurerm_key_vault_access_policy.read_secrets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.read_secrets_staging_slot](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_linux_web_app.web_app](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app) | resource |
| [azurerm_linux_web_app_slot.staging](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app_slot) | resource |
| [azurerm_monitor_activity_log_alert.app_service_stop](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_activity_log_alert) | resource |
| [azurerm_monitor_diagnostic_setting.web_app_logs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_metric_alert.app_service_http_5xx](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.app_service_response_time](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_private_endpoint.private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.private_endpoint_staging](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_container_registry.acr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/container_registry) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_action_group_ids"></a> [action\_group\_ids](#input\_action\_group\_ids) | The IDs of the Azure Monitor action groups for different alert types | <pre>object({<br>    tech            = string,<br>    service_manager = string,<br>    iap             = string,<br>    its             = string,<br>    info_sec        = string<br>  })</pre> | n/a | yes |
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | The name of the app service | `string` | n/a | yes |
| <a name="input_app_service_plan_id"></a> [app\_service\_plan\_id](#input\_app\_service\_plan\_id) | The id of the app service plan | `string` | n/a | yes |
| <a name="input_app_service_plan_resource_group_name"></a> [app\_service\_plan\_resource\_group\_name](#input\_app\_service\_plan\_resource\_group\_name) | The App Service Plan resource group name required for custom hostname certificate placement | `string` | `null` | no |
| <a name="input_app_service_private_dns_zone_id"></a> [app\_service\_private\_dns\_zone\_id](#input\_app\_service\_private\_dns\_zone\_id) | The id of the private DNS zone for App services | `string` | `null` | no |
| <a name="input_app_settings"></a> [app\_settings](#input\_app\_settings) | The environment variables to be passed to the application | `map(string)` | `{}` | no |
| <a name="input_container_registry_name"></a> [container\_registry\_name](#input\_container\_registry\_name) | The name of the container registry that hosts the image | `string` | n/a | yes |
| <a name="input_container_registry_rg"></a> [container\_registry\_rg](#input\_container\_registry\_rg) | The resource group of the container registry that hosts the image | `string` | n/a | yes |
| <a name="input_custom_hostname"></a> [custom\_hostname](#input\_custom\_hostname) | The custom hostname applied to the App Service required for auth redirection with a reverse proxy | `string` | `null` | no |
| <a name="input_custom_hostname_certificate_secret_id"></a> [custom\_hostname\_certificate\_secret\_id](#input\_custom\_hostname\_certificate\_secret\_id) | The Key Vault secret URL for the custom hostname SSL certificate | `string` | `null` | no |
| <a name="input_endpoint_subnet_id"></a> [endpoint\_subnet\_id](#input\_endpoint\_subnet\_id) | The id of the private endpoint subnet the app service is linked to for ingress traffic | `string` | `null` | no |
| <a name="input_front_door_restriction"></a> [front\_door\_restriction](#input\_front\_door\_restriction) | Flag to indicate if the web app should be restricted so it can only be accessed via Front Door | `bool` | `false` | no |
| <a name="input_health_check_path"></a> [health\_check\_path](#input\_health\_check\_path) | The path of the service's health check endpoint | `string` | `null` | no |
| <a name="input_image_name"></a> [image\_name](#input\_image\_name) | The name of the image deployed to the App Service | `string` | n/a | yes |
| <a name="input_inbound_vnet_connectivity"></a> [inbound\_vnet\_connectivity](#input\_inbound\_vnet\_connectivity) | Indicates whether inbound connectivity (Private Endpoint) is required | `bool` | `false` | no |
| <a name="input_integration_subnet_id"></a> [integration\_subnet\_id](#input\_integration\_subnet\_id) | The id of the vnet integration subnet the app service is linked to for egress traffic | `string` | `null` | no |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | The ID of the key vault so the App Service can pull secret values | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The name of the app service location | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | The ID of the Azure Monitor Log Analytics Workspace | `string` | n/a | yes |
| <a name="input_monitoring_alerts_enabled"></a> [monitoring\_alerts\_enabled](#input\_monitoring\_alerts\_enabled) | Indicates whether Azure Monitor alerts are enabled for App Service | `bool` | `false` | no |
| <a name="input_outbound_vnet_connectivity"></a> [outbound\_vnet\_connectivity](#input\_outbound\_vnet\_connectivity) | Indicates whether outbound connectivity (VNET Integration) is required | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group | `string` | n/a | yes |
| <a name="input_resource_suffix"></a> [resource\_suffix](#input\_resource\_suffix) | The suffix for resource naming | `string` | n/a | yes |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | The name of the service the app belongs to | `string` | n/a | yes |
| <a name="input_slot_setting_overrides"></a> [slot\_setting\_overrides](#input\_slot\_setting\_overrides) | The environment variable names that should be different on slots, will be marked as sticky | `map(string)` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags applied to all resources | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_default_site_hostname"></a> [default\_site\_hostname](#output\_default\_site\_hostname) | The Default Hostname associated with the App Service |
| <a name="output_id"></a> [id](#output\_id) | The ID of the App Service |
| <a name="output_principal_id"></a> [principal\_id](#output\_principal\_id) | The ID of the principal associated with the App Service |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
