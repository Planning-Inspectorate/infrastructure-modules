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
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.96.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_azure_region_uks"></a> [azure\_region\_uks](#module\_azure\_region\_uks) | claranet/regions/azurerm | 5.1.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_cdn_frontdoor_custom_domain.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_custom_domain) | resource |
| [azurerm_cdn_frontdoor_custom_domain_association.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_custom_domain_association) | resource |
| [azurerm_cdn_frontdoor_endpoint.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_endpoint) | resource |
| [azurerm_cdn_frontdoor_firewall_policy.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_firewall_policy) | resource |
| [azurerm_cdn_frontdoor_origin.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_origin) | resource |
| [azurerm_cdn_frontdoor_origin_group.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_origin_group) | resource |
| [azurerm_cdn_frontdoor_profile.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_profile) | resource |
| [azurerm_cdn_frontdoor_route.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_route) | resource |
| [azurerm_cdn_frontdoor_rule_set.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_rule_set) | resource |
| [azurerm_cdn_frontdoor_security_policy.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_security_policy) | resource |
| [azurerm_log_analytics_workspace.frontdoor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_monitor_diagnostic_setting.frontdoor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_resource_group.frontdoor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | The common resource tags for the project | `map(string)` | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Public domain name | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment Name | `string` | n/a | yes |
| <a name="input_frontend_endpoint"></a> [frontend\_endpoint](#input\_frontend\_endpoint) | The endpoint for the frontend | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The location the App Services are deployed to in slug format e.g. 'uk-south' | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the resource. | `string` | n/a | yes |
| <a name="input_origin"></a> [origin](#input\_origin) | CDN FrontDoor Origins configurations. | <pre>map(object({<br>    name                           = string<br>    custom_resource_name           = optional(string)<br>    origin_group_name              = string<br>    enabled                        = optional(bool, true)<br>    certificate_name_check_enabled = optional(bool, true)<br><br>    host_name          = string<br>    http_port          = optional(number, 80)<br>    https_port         = optional(number, 443)<br>    origin_host_header = optional(string)<br>    priority           = optional(number, 5)<br>    weight             = optional(number, 100)<br><br>    private_link = optional(object({<br>      request_message        = optional(string)<br>      target_type            = optional(string)<br>      location               = string<br>      private_link_target_id = string<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_route"></a> [route](#input\_route) | CDN FrontDoor Routes configurations. | <pre>map(object({<br>    name                 = string<br>    custom_resource_name = optional(string)<br>    enabled              = optional(bool, true)<br><br>    endpoint_name     = string<br>    origin_group_name = string<br>    origins_names     = list(string)<br><br>    forwarding_protocol = optional(string, "MatchRequest")<br>    patterns_to_match   = optional(list(string), ["/*"])<br>    supported_protocols = optional(list(string), ["Https"])<br>    cache = optional(object({<br>      query_string_caching_behavior = optional(string, "IgnoreQueryString")<br>      query_strings                 = optional(list(string))<br>      compression_enabled           = optional(bool, false)<br>      content_types_to_compress     = optional(list(string))<br>    }))<br><br>    custom_domains_names = optional(list(string), [])<br>    origin_path          = optional(string)<br>    rule_sets_names      = optional(list(string), [])<br><br>    https_redirect_enabled = optional(bool, true)<br>    link_to_default_domain = optional(bool, true)<br>  }))</pre> | n/a | yes |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | Specifies the SKU for this Front Door Profile. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_front_door_profile_id"></a> [front\_door\_profile\_id](#output\_front\_door\_profile\_id) | ID of the Azure Front Door Profile |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
