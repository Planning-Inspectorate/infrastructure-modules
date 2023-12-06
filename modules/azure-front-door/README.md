# Front Door

This component contains the Azure Front Door and WAF resources. The resources in this stack are global.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.7, < 3.74.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.83.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_azure_region"></a> [azure\_region](#module\_azure\_region) | claranet/regions/azurerm | 5.1.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_cdn_frontdoor_custom_domain.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_custom_domain) | resource |
| [azurerm_cdn_frontdoor_endpoint.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_endpoint) | resource |
| [azurerm_cdn_frontdoor_firewall_policy.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_firewall_policy) | resource |
| [azurerm_cdn_frontdoor_origin.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_origin) | resource |
| [azurerm_cdn_frontdoor_origin_group.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_origin_group) | resource |
| [azurerm_cdn_frontdoor_profile.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_profile) | resource |
| [azurerm_cdn_frontdoor_route.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_route) | resource |
| [azurerm_cdn_frontdoor_rule_set.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_rule_set) | resource |
| [azurerm_cdn_frontdoor_security_policy.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_security_policy) | resource |
| [azurerm_monitor_diagnostic_setting.front_door_waf](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_resource_group.frontdoor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cdn_frontdoor_origin_path"></a> [cdn\_frontdoor\_origin\_path](#input\_cdn\_frontdoor\_origin\_path) | A directory path on the Front Door Origin that can be used to retrieve content | `string` | n/a | yes |
| <a name="input_certificate_name_check_enabled"></a> [certificate\_name\_check\_enabled](#input\_certificate\_name\_check\_enabled) | Specifies whether certificate name checks are enabled for this origin | `bool` | `false` | no |
| <a name="input_common_log_analytics_workspace_id"></a> [common\_log\_analytics\_workspace\_id](#input\_common\_log\_analytics\_workspace\_id) | The ID for the common Log Analytics Workspace | `string` | n/a | yes |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | The common resource tags for the project | `map(string)` | n/a | yes |
| <a name="input_forwarding_protocol"></a> [forwarding\_protocol](#input\_forwarding\_protocol) | The forwarding protocol set for the cdn frontdoor route | `string` | `"MatchRequest"` | no |
| <a name="input_front_door_sku_name"></a> [front\_door\_sku\_name](#input\_front\_door\_sku\_name) | The SKU name of the Front Door | `string` | `"Premium_AzureFrontDoor"` | no |
| <a name="input_front_door_waf_mode"></a> [front\_door\_waf\_mode](#input\_front\_door\_waf\_mode) | Indicates if the Web Application Firewall should be in Detection or Prevention mode | `string` | `"Detection"` | no |
| <a name="input_host_name"></a> [host\_name](#input\_host\_name) | The host name of the resource | `string` | n/a | yes |
| <a name="input_https_redirect_enabled"></a> [https\_redirect\_enabled](#input\_https\_redirect\_enabled) | Setting to select if this Front Door Route should automatically redirect HTTP traffic to HTTPS traffic | `bool` | `true` | no |
| <a name="input_link_to_default_domain"></a> [link\_to\_default\_domain](#input\_link\_to\_default\_domain) | Setting to select if this Front Door Route be linked to the default endpoint | `bool` | `true` | no |
| <a name="input_location"></a> [location](#input\_location) | The location resources are deployed to in slug format e.g. 'uk-west' | `string` | `"uk-south"` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the resource | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group | `string` | n/a | yes |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | The name of the service the Front Door belongs to | `string` | n/a | yes |
| <a name="input_session_affinity_enabled"></a> [session\_affinity\_enabled](#input\_session\_affinity\_enabled) | The forwarding protocol set for the cdn frontdoor route | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_frontend_endpoints"></a> [frontend\_endpoints](#output\_frontend\_endpoints) | A map of frontend endpoints within the Front Door instance |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
