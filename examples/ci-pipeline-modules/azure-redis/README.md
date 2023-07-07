# azure-redis

This directory stands up a Redis cache instance.

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
| <a name="module_redis"></a> [redis](#module\_redis) | ../../azure-redis | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Name of the application | `string` | n/a | yes |
| <a name="input_capacity"></a> [capacity](#input\_capacity) | The size of the Redis cache to deploy | `number` | `2` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name. Used as a tag and in naming the resource group | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The region resources will be deployed to | `string` | `"northeurope"` | no |
| <a name="input_redis_firewall_rules"></a> [redis\_firewall\_rules](#input\_redis\_firewall\_rules) | "Map of maps Redis firewall rules containing start and end IPs. Names must be alphanumeric only. Example format:<br>name1 = {<br>  start\_ip                  = "1.2.3.5"<br>  end\_ip                    = "1.2.3.10"<br>}<br>name2 = {<br>  start\_ip                  = "2.0.0.1"<br>  end\_ip                    = "2.0.1.0"<br>}" | `map(map(string))` | `{}` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | Tier required : Basic/Standard | `string` | `"Standard"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to be applied to resources | `map(string)` | `{}` | no |

## Outputs

No outputs.
