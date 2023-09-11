# Front Door

This component contains the Azure Front Door and WAF resources. The resources in this stack are global.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.6, < 3.64.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.64.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.64.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_azure_region_uks"></a> [azure\_region\_uks](#module\_azure\_region\_uks) | claranet/regions/azurerm | 4.2.1 |

## Resources

| Name | Type |
|------|------|
| [azurerm_cdn_frontdoor_custom_domain.back_office_appeals_service](https://registry.terraform.io/providers/hashicorp/azurerm/3.64.0/docs/resources/cdn_frontdoor_custom_domain) | resource |
| [azurerm_cdn_frontdoor_custom_domain.back_office_applications_service](https://registry.terraform.io/providers/hashicorp/azurerm/3.64.0/docs/resources/cdn_frontdoor_custom_domain) | resource |
| [azurerm_cdn_frontdoor_custom_domain.common](https://registry.terraform.io/providers/hashicorp/azurerm/3.64.0/docs/resources/cdn_frontdoor_custom_domain) | resource |
| [azurerm_cdn_frontdoor_endpoint.back_office_appeals_service](https://registry.terraform.io/providers/hashicorp/azurerm/3.64.0/docs/resources/cdn_frontdoor_endpoint) | resource |
| [azurerm_cdn_frontdoor_endpoint.back_office_applications_service](https://registry.terraform.io/providers/hashicorp/azurerm/3.64.0/docs/resources/cdn_frontdoor_endpoint) | resource |
| [azurerm_cdn_frontdoor_endpoint.common](https://registry.terraform.io/providers/hashicorp/azurerm/3.64.0/docs/resources/cdn_frontdoor_endpoint) | resource |
| [azurerm_cdn_frontdoor_firewall_policy.back_office_appeals_service](https://registry.terraform.io/providers/hashicorp/azurerm/3.64.0/docs/resources/cdn_frontdoor_firewall_policy) | resource |
| [azurerm_cdn_frontdoor_firewall_policy.back_office_applications_service](https://registry.terraform.io/providers/hashicorp/azurerm/3.64.0/docs/resources/cdn_frontdoor_firewall_policy) | resource |
| [azurerm_cdn_frontdoor_firewall_policy.default](https://registry.terraform.io/providers/hashicorp/azurerm/3.64.0/docs/resources/cdn_frontdoor_firewall_policy) | resource |
| [azurerm_cdn_frontdoor_origin.back_office_appeals_service](https://registry.terraform.io/providers/hashicorp/azurerm/3.64.0/docs/resources/cdn_frontdoor_origin) | resource |
| [azurerm_cdn_frontdoor_origin.back_office_applications_service](https://registry.terraform.io/providers/hashicorp/azurerm/3.64.0/docs/resources/cdn_frontdoor_origin) | resource |
| [azurerm_cdn_frontdoor_origin.common](https://registry.terraform.io/providers/hashicorp/azurerm/3.64.0/docs/resources/cdn_frontdoor_origin) | resource |
| [azurerm_cdn_frontdoor_origin_group.back_office_appeals_service](https://registry.terraform.io/providers/hashicorp/azurerm/3.64.0/docs/resources/cdn_frontdoor_origin_group) | resource |
| [azurerm_cdn_frontdoor_origin_group.back_office_applications_service](https://registry.terraform.io/providers/hashicorp/azurerm/3.64.0/docs/resources/cdn_frontdoor_origin_group) | resource |
| [azurerm_cdn_frontdoor_origin_group.common](https://registry.terraform.io/providers/hashicorp/azurerm/3.64.0/docs/resources/cdn_frontdoor_origin_group) | resource |
| [azurerm_cdn_frontdoor_profile.back_office_appeals_service](https://registry.terraform.io/providers/hashicorp/azurerm/3.64.0/docs/resources/cdn_frontdoor_profile) | resource |
| [azurerm_cdn_frontdoor_profile.back_office_applications_service](https://registry.terraform.io/providers/hashicorp/azurerm/3.64.0/docs/resources/cdn_frontdoor_profile) | resource |
| [azurerm_cdn_frontdoor_profile.common](https://registry.terraform.io/providers/hashicorp/azurerm/3.64.0/docs/resources/cdn_frontdoor_profile) | resource |
| [azurerm_cdn_frontdoor_route.back_office_appeals_service](https://registry.terraform.io/providers/hashicorp/azurerm/3.64.0/docs/resources/cdn_frontdoor_route) | resource |
| [azurerm_cdn_frontdoor_route.back_office_applications_service](https://registry.terraform.io/providers/hashicorp/azurerm/3.64.0/docs/resources/cdn_frontdoor_route) | resource |
| [azurerm_cdn_frontdoor_route.common](https://registry.terraform.io/providers/hashicorp/azurerm/3.64.0/docs/resources/cdn_frontdoor_route) | resource |
| [azurerm_cdn_frontdoor_rule.addrobotstagheader](https://registry.terraform.io/providers/hashicorp/azurerm/3.64.0/docs/resources/cdn_frontdoor_rule) | resource |
| [azurerm_cdn_frontdoor_rule.book_reference_file](https://registry.terraform.io/providers/hashicorp/azurerm/3.64.0/docs/resources/cdn_frontdoor_rule) | resource |
| [azurerm_cdn_frontdoor_rule_set.search_indexing](https://registry.terraform.io/providers/hashicorp/azurerm/3.64.0/docs/resources/cdn_frontdoor_rule_set) | resource |
| [azurerm_cdn_frontdoor_security_policy.back_office_appeals_service](https://registry.terraform.io/providers/hashicorp/azurerm/3.64.0/docs/resources/cdn_frontdoor_security_policy) | resource |
| [azurerm_cdn_frontdoor_security_policy.back_office_applications_service](https://registry.terraform.io/providers/hashicorp/azurerm/3.64.0/docs/resources/cdn_frontdoor_security_policy) | resource |
| [azurerm_cdn_frontdoor_security_policy.common](https://registry.terraform.io/providers/hashicorp/azurerm/3.64.0/docs/resources/cdn_frontdoor_security_policy) | resource |
| [azurerm_frontdoor.common](https://registry.terraform.io/providers/hashicorp/azurerm/3.64.0/docs/resources/frontdoor) | resource |
| [azurerm_frontdoor_firewall_policy.default](https://registry.terraform.io/providers/hashicorp/azurerm/3.64.0/docs/resources/frontdoor_firewall_policy) | resource |
| [azurerm_frontdoor_rules_engine.search_indexing](https://registry.terraform.io/providers/hashicorp/azurerm/3.64.0/docs/resources/frontdoor_rules_engine) | resource |
| [azurerm_monitor_diagnostic_setting.front_door_waf](https://registry.terraform.io/providers/hashicorp/azurerm/3.64.0/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_resource_group.frontdoor](https://registry.terraform.io/providers/hashicorp/azurerm/3.64.0/docs/resources/resource_group) | resource |
| [null_resource.fd_routing_noindex](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_appeals_service_primary_app_service_url"></a> [appeals\_service\_primary\_app\_service\_url](#input\_appeals\_service\_primary\_app\_service\_url) | The primary App Service URL for the Appeals Service | `string` | n/a | yes |
| <a name="input_appeals_service_public_url"></a> [appeals\_service\_public\_url](#input\_appeals\_service\_public\_url) | The public URL for the Appeals Service frontend web app | `string` | n/a | yes |
| <a name="input_appeals_service_secondary_app_service_url"></a> [appeals\_service\_secondary\_app\_service\_url](#input\_appeals\_service\_secondary\_app\_service\_url) | The secondary App Service URL for the Appeals Service | `string` | `""` | no |
| <a name="input_appeals_service_ssl_certificate_name"></a> [appeals\_service\_ssl\_certificate\_name](#input\_appeals\_service\_ssl\_certificate\_name) | The SSL certificate name in the environment Key Vault for the appeals service | `string` | `"pins-wildcard"` | no |
| <a name="input_applications_service_primary_app_service_url"></a> [applications\_service\_primary\_app\_service\_url](#input\_applications\_service\_primary\_app\_service\_url) | The primary App Service URL for the Applications Service | `string` | n/a | yes |
| <a name="input_applications_service_public_url"></a> [applications\_service\_public\_url](#input\_applications\_service\_public\_url) | The public URL for the Applications Service frontend web app | `string` | n/a | yes |
| <a name="input_applications_service_secondary_app_service_url"></a> [applications\_service\_secondary\_app\_service\_url](#input\_applications\_service\_secondary\_app\_service\_url) | The secondary App Service URL for the Applications Service | `string` | `""` | no |
| <a name="input_applications_service_ssl_certificate_name"></a> [applications\_service\_ssl\_certificate\_name](#input\_applications\_service\_ssl\_certificate\_name) | The SSL certificate name in the environment Key Vault for the applications service | `string` | `"pins-wildcard"` | no |
| <a name="input_back_office_appeals_primary_app_service_url"></a> [back\_office\_appeals\_primary\_app\_service\_url](#input\_back\_office\_appeals\_primary\_app\_service\_url) | The primary App Service URL for the Back Office Appeals | `string` | n/a | yes |
| <a name="input_back_office_appeals_public_url"></a> [back\_office\_appeals\_public\_url](#input\_back\_office\_appeals\_public\_url) | The public URL for the Back Office Appeals frontend web app | `string` | n/a | yes |
| <a name="input_back_office_appeals_secondary_app_service_url"></a> [back\_office\_appeals\_secondary\_app\_service\_url](#input\_back\_office\_appeals\_secondary\_app\_service\_url) | The secondary App Service URL for the Back Office Appeals | `string` | `""` | no |
| <a name="input_back_office_appeals_ssl_certificate_name"></a> [back\_office\_appeals\_ssl\_certificate\_name](#input\_back\_office\_appeals\_ssl\_certificate\_name) | The SSL certificate name in the environment Key Vault for the back office appeals service | `string` | `"pins-wildcard"` | no |
| <a name="input_back_office_primary_app_service_url"></a> [back\_office\_primary\_app\_service\_url](#input\_back\_office\_primary\_app\_service\_url) | The primary App Service URL for the Back Office | `string` | n/a | yes |
| <a name="input_back_office_public_url"></a> [back\_office\_public\_url](#input\_back\_office\_public\_url) | The public URL for the Back Office frontend web app | `string` | n/a | yes |
| <a name="input_back_office_secondary_app_service_url"></a> [back\_office\_secondary\_app\_service\_url](#input\_back\_office\_secondary\_app\_service\_url) | The secondary App Service URL for the Back Office | `string` | `""` | no |
| <a name="input_back_office_ssl_certificate_name"></a> [back\_office\_ssl\_certificate\_name](#input\_back\_office\_ssl\_certificate\_name) | The SSL certificate name in the environment Key Vault for the back office service | `string` | `"pins-wildcard"` | no |
| <a name="input_common_log_analytics_workspace_id"></a> [common\_log\_analytics\_workspace\_id](#input\_common\_log\_analytics\_workspace\_id) | The ID for the common Log Analytics Workspace | `string` | n/a | yes |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | The common resource tags for the project | `map(string)` | n/a | yes |
| <a name="input_enable_search_indexing_by_default"></a> [enable\_search\_indexing\_by\_default](#input\_enable\_search\_indexing\_by\_default) | A flag to indicate if the environment should enable search indexing for frontends by default | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment resources are deployed to e.g. 'dev' | `string` | n/a | yes |
| <a name="input_feature_front_door_failover_enaled"></a> [feature\_front\_door\_failover\_enaled](#input\_feature\_front\_door\_failover\_enaled) | Whether or not the backend pools should be created with both the primary and secondary app service urls. This feature flag is temporary. | `bool` | `false` | no |
| <a name="input_front_door_sku_name"></a> [front\_door\_sku\_name](#input\_front\_door\_sku\_name) | The SKU name of the Front Door | `string` | `"Premium_AzureFrontDoor"` | no |
| <a name="input_front_door_waf_mode"></a> [front\_door\_waf\_mode](#input\_front\_door\_waf\_mode) | Indicates if the Web Application Firewall should be in Detection or Prevention mode | `string` | `"Detection"` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | The environment instance for use if multiple environments are deployed to a subscription | `string` | `"001"` | no |
| <a name="input_location"></a> [location](#input\_location) | The location resources are deployed to in slug format e.g. 'uk-west' | `string` | `"uk-west"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_frontend_endpoint_mappings"></a> [frontend\_endpoint\_mappings](#output\_frontend\_endpoint\_mappings) | A map of maps containing configuration options for each frontend endpoint |
| <a name="output_frontend_endpoints"></a> [frontend\_endpoints](#output\_frontend\_endpoints) | A map of frontend endpoints within the Front Door instance |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
