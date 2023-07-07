# app-service-function

Creates an Azure App Service (Function)

## How To Use

### Function App

```terraform
module "func" {
  source                     = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-app-service"
  app_service_plan_id        = module.asp.id
  environment                = var.environment
  application                = var.application
  location                   = var.location
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key
}
```

## How To Update this README.md

* terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* Follow the setup instructions [here](https://github.com/segmentio/terraform-docs)
* Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2, < 3 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3, < 4 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >=0.7, < 1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 2, < 3 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3, < 4 |
| <a name="provider_time"></a> [time](#provider\_time) | >=0.7, < 1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_function_app.function](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [random_string.rand](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [time_static.t](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_service_plan_id"></a> [app\_service\_plan\_id](#input\_app\_service\_plan\_id) | ID of the app service plan instance to host this app service. If unspecified one will be created for you | `any` | `null` | no |
| <a name="input_app_settings"></a> [app\_settings](#input\_app\_settings) | Function application settings | `map(string)` | `{}` | no |
| <a name="input_application"></a> [application](#input\_application) | Name of the application | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name. Used as a tag and in naming the resource group | `string` | n/a | yes |
| <a name="input_function_version"></a> [function\_version](#input\_function\_version) | The function version. ~1 through ~4 | `string` | `"~3"` | no |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | List of service principal IDs if you want to use a User Assigned Identity over a System Assigned Identity | `list(string)` | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | The region resources will be deployed to | `string` | `"northeurope"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The target resource group this module should be deployed into. If not specified one will be created for you with name like: environment-application-template-location | `string` | `""` | no |
| <a name="input_site_config"></a> [site\_config](#input\_site\_config) | Site config to override site\_config\_defaults. Object structure identical to site\_config\_defaults | `map` | `{}` | no |
| <a name="input_site_config_defaults"></a> [site\_config\_defaults](#input\_site\_config\_defaults) | A site config block for configuring the function | <pre>object({<br>    always_on = bool<br>    cors = object({<br>      allowed_origins     = list(string)<br>      support_credentials = bool<br>    })<br>    ftps_state                  = string<br>    health_check_path           = string<br>    http2_enabled               = bool<br>    java_version                = string<br>    linux_fx_version            = string<br>    dotnet_framework_version    = string<br>    min_tls_version             = string<br>    pre_warmed_instance_count   = number<br>    scm_ip_restriction          = list(any)<br>    scm_type                    = string<br>    scm_use_main_ip_restriction = bool<br>    use_32_bit_worker_process   = bool<br>    websockets_enabled          = bool<br>    vnet_route_all_enabled      = bool<br>    ip_restrictions = object({<br>      ip_addresses = list(object({<br>        rule_name  = string<br>        ip_address = string<br>        priority   = number<br>        action     = string<br>      }))<br>      service_tags = list(object({<br>        rule_name        = string<br>        service_tag_name = string<br>        priority         = number<br>        action           = string<br>      }))<br>      subnet_ids = list(object({<br>        rule_name = string<br>        subnet_id = string<br>        priority  = number<br>        action    = string<br>      }))<br>    })<br>  })</pre> | <pre>{<br>  "always_on": true,<br>  "cors": {<br>    "allowed_origins": [<br>      "*"<br>    ],<br>    "support_credentials": false<br>  },<br>  "dotnet_framework_version": "v4.0",<br>  "ftps_state": "Disabled",<br>  "health_check_path": null,<br>  "http2_enabled": true,<br>  "ip_restrictions": {<br>    "ip_addresses": [],<br>    "service_tags": [],<br>    "subnet_ids": []<br>  },<br>  "java_version": null,<br>  "linux_fx_version": null,<br>  "min_tls_version": "1.2",<br>  "pre_warmed_instance_count": null,<br>  "scm_ip_restriction": [],<br>  "scm_type": "None",<br>  "scm_use_main_ip_restriction": true,<br>  "use_32_bit_worker_process": false,<br>  "vnet_route_all_enabled": false,<br>  "websockets_enabled": true<br>}</pre> | no |
| <a name="input_storage_account_access_key"></a> [storage\_account\_access\_key](#input\_storage\_account\_access\_key) | The key to access the backend storage account | `string` | `null` | no |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | The name of the backend storage account | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to be applied to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_hostname"></a> [hostname](#output\_hostname) | Id of the function app |
| <a name="output_id"></a> [id](#output\_id) | Id of the function app |
| <a name="output_identity"></a> [identity](#output\_identity) | Identity block function app managed identity |
| <a name="output_name"></a> [name](#output\_name) | Name of the function app |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Name of the resource group where resources have been deployed to |
