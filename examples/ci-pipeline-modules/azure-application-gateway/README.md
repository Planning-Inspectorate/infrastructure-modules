# azure-application-gateway

CI for Azure Application Gateway.

## How To Update this README.md

* terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 2 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gateway"></a> [gateway](#module\_gateway) | ../../azure-application-gateway | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Name of the application | `string` | n/a | yes |
| <a name="input_autoscale_max_capacity"></a> [autoscale\_max\_capacity](#input\_autoscale\_max\_capacity) | Max size the Application Gateway can scale to. Must be larger than min (2) | `number` | `3` | no |
| <a name="input_backend_http_settings"></a> [backend\_http\_settings](#input\_backend\_http\_settings) | List of backend settings, there must be at least one | `list(map(string))` | n/a | yes |
| <a name="input_backend_pool"></a> [backend\_pool](#input\_backend\_pool) | List of backend pools to be created with fqdns or IPs, there must be at least one | <pre>list(object({<br>    name  = string<br>    fqdns = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_ciphers"></a> [ciphers](#input\_ciphers) | List of acceptable ciphers, this list has been signed off by Infosec | `list(string)` | <pre>[<br>  "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256",<br>  "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384",<br>  "TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA",<br>  "TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA",<br>  "TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256",<br>  "TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384",<br>  "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384",<br>  "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256",<br>  "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA",<br>  "TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA",<br>  "TLS_RSA_WITH_AES_256_GCM_SHA384",<br>  "TLS_RSA_WITH_AES_128_GCM_SHA256",<br>  "TLS_RSA_WITH_AES_256_CBC_SHA256",<br>  "TLS_RSA_WITH_AES_128_CBC_SHA256",<br>  "TLS_RSA_WITH_AES_256_CBC_SHA",<br>  "TLS_RSA_WITH_AES_128_CBC_SHA"<br>]</pre> | no |
| <a name="input_disabled_rule_groups"></a> [disabled\_rule\_groups](#input\_disabled\_rule\_groups) | List of disabled OWASP rules | <pre>list(object({<br>    rule_group_name = list(string)<br>    rules           = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name. Used as a tag and in naming the resource group | `string` | n/a | yes |
| <a name="input_exclusions"></a> [exclusions](#input\_exclusions) | Exceptions to be allowed through the WAF | `list(map(string))` | `[]` | no |
| <a name="input_http_listeners"></a> [http\_listeners](#input\_http\_listeners) | List of listeners, there must be at least one | `list(map(string))` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The region resources will be deployed to | `string` | `"northeurope"` | no |
| <a name="input_probes"></a> [probes](#input\_probes) | List of probes | `list(map(string))` | `null` | no |
| <a name="input_redirections"></a> [redirections](#input\_redirections) | List of redirection blocks | `list(map(string))` | `[]` | no |
| <a name="input_request_routing_rules"></a> [request\_routing\_rules](#input\_request\_routing\_rules) | List of routing rules, there must be at least one | `list(map(string))` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The target resource group this module should be deployed into. If not specified one will be created for you with name like: environment-application-template-location | `string` | `""` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | The 'model' to use. Can be: Standard\_Medium, Standard\_Large, Standard\_V2, WAF\_Medium, WAF\_Large, WAF\_V2 | `string` | `"WAF_V2"` | no |
| <a name="input_sku_tier"></a> [sku\_tier](#input\_sku\_tier) | The 'model' to use. Can be: Standard, Satndard\_V2, WAF, WAF\_V2 | `string` | `"WAF_V2"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The size and location of the subnet to house the gateway. A /28 netmask is a good choice | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to be applied to resources | `map(string)` | `{}` | no |
| <a name="input_waf_configuration_firewall_mode"></a> [waf\_configuration\_firewall\_mode](#input\_waf\_configuration\_firewall\_mode) | Firewall mode. Dectection or Prevention | `string` | `"Prevention"` | no |

## Outputs

No outputs.
