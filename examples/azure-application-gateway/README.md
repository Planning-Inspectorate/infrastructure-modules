# azure-application-gateway

This repository will provision Azure Application Gateway.

## How To Use

Use an existing tfvar environment file as a guide. This module is rather conplex due to the number of dynamic blocks in motion.

The properties of an Azure Application Gateway are constructed from lists of maps which are looped through in the resource definition.

```HCL
module "gateway" {
  source = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-application-gateway"
  resource_group_name = azurerm_resource_group.gateway.name
  environment         = var.environment
  application         = var.application
  location            = var.location
  tags                = local.tags
  subnet_id           = module.subnet.subnet_id
  backend_pool = [
    {
      name  = "ci"
      fqdns = ["notfake.azure.hiscox.com"]
    }
  ]
  http_listeners = [
    {
      name                           = "website-insecure"
      frontend_ip_configuration_name = "privateip"
      host_name                      = "somehostname.bacon.com"
      frontend_port_name             = "insecure"
      protocol                       = "Http"
      ssl_certificate_name           = null
    }
  ]
  probes = [
    {
      name                = "ci"
      interval            = 30
      protocol            = "http"
      path                = "/healthcheck"
      timeout             = 30
      unhealthy_threshold = 3
      host                = "notfake.azure.hiscox.com"
    }
  ]
  backend_http_settings = [
    {
      name                  = "website-backend-settings"
      cookie_based_affinity = "Enabled"
      port                  = 80
      protocol              = "Http"
      request_timeout       = "10"
      probe_name            = "ci"
    }
  ]
  request_routing_rules = [
    {
      name                        = "ci-route"
      rule_type                   = "Basic"
      http_listener_name          = "website-insecure"
      backend_address_pool_name   = "ci"
      backend_http_settings_name  = "website-backend-settings"
      redirect_configuration_name = null
    }
  ]
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
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2.18, < 3 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >=0.7, < 1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 2.18, < 3 |
| <a name="provider_time"></a> [time](#provider\_time) | >=0.7, < 1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_application_gateway.waf](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway) | resource |
| [azurerm_public_ip.public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_web_application_firewall_policy.waf_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/web_application_firewall_policy) | resource |
| [time_static.t](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subnet.sn](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

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
| <a name="input_rewrite_rule_set"></a> [rewrite\_rule\_set](#input\_rewrite\_rule\_set) | List of rewrite rule sets | `list(map(string))` | `[]` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | The 'model' to use. Can be: Standard\_Medium, Standard\_Large, Standard\_V2, WAF\_Medium, WAF\_Large, WAF\_V2 | `string` | `"WAF_V2"` | no |
| <a name="input_sku_tier"></a> [sku\_tier](#input\_sku\_tier) | The 'model' to use. Can be: Standard, Satndard\_V2, WAF, WAF\_V2 | `string` | `"WAF_V2"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The size and location of the subnet to house the gateway. A /28 netmask is a good choice | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to be applied to resources | `map(string)` | `{}` | no |
| <a name="input_waf_configuration_firewall_mode"></a> [waf\_configuration\_firewall\_mode](#input\_waf\_configuration\_firewall\_mode) | Firewall mode. Dectection or Prevention | `string` | `"Prevention"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | ID of the AAG |
| <a name="output_name"></a> [name](#output\_name) | Name of the AAG |
| <a name="output_private_ip"></a> [private\_ip](#output\_private\_ip) | Private IP |
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | Public IP |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Name of the resource group where resources have been deployed to |
