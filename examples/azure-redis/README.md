# azure-redis

This directory stands up a Redis cache instance.

## How To Use

Include example code snippets:

### Example One

```terraform
module "redis" {
  source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-redis"
  environment = "dev"
  application = "app"
  location    = "northeurope"
  sku_name    = "Standard"
  capacity    = 2
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
| [azurerm_redis_cache.redis](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/redis_cache) | resource |
| [azurerm_redis_firewall_rule.rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/redis_firewall_rule) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [time_static.t](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Name of the application | `string` | n/a | yes |
| <a name="input_capacity"></a> [capacity](#input\_capacity) | The size of the Redis cache to deploy | `number` | `2` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name. Used as a tag and in naming the resource group | `string` | n/a | yes |
| <a name="input_family"></a> [family](#input\_family) | Redis tier family | `map(string)` | <pre>{<br>  "Basic": "C",<br>  "Standard": "C"<br>}</pre> | no |
| <a name="input_location"></a> [location](#input\_location) | The region resources will be deployed to | `string` | `"northeurope"` | no |
| <a name="input_redis_firewall_rules"></a> [redis\_firewall\_rules](#input\_redis\_firewall\_rules) | "Map of maps Redis firewall rules containing start and end IPs. Names must be alphanumeric only. Example format:<br>name1 = {<br>  start\_ip                  = "1.2.3.5"<br>  end\_ip                    = "1.2.3.10"<br>}<br>name2 = {<br>  start\_ip                  = "2.0.0.1"<br>  end\_ip                    = "2.0.1.0"<br>}" | `map(map(string))` | `{}` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The target resource group this module should be deployed into. If not specified one will be created for you with name like: environment-application-template-location | `string` | `""` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | Tier required : Basic/Standard | `string` | `"Standard"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to be applied to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_hostname"></a> [hostname](#output\_hostname) | The Hostname of the Redis Instance |
| <a name="output_id"></a> [id](#output\_id) | The Route ID |
| <a name="output_port"></a> [port](#output\_port) | The non-SSL Port of the Redis Instance |
| <a name="output_primary_access_key"></a> [primary\_access\_key](#output\_primary\_access\_key) | The Primary Access Key for the Redis Instance |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Name of the resource group where resources have been deployed to |
| <a name="output_secondary_access_key"></a> [secondary\_access\_key](#output\_secondary\_access\_key) | The Secondary Access Key for the Redis Instance |
| <a name="output_ssl_port"></a> [ssl\_port](#output\_ssl\_port) | The SSL Port of Redis Instance |
