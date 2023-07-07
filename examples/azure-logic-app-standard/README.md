# azure-logic-app-standard

This directory contains code that is used to deploy an Azure Logic App Standard. Note that to restrict outbound traffic from the App to a private network you should use the `azurerm_app_service_virtual_network_swift_connection` resource and add an `app_setting` called "WEBSITE\_VNET\_ROUTE\_ALL" with a value of "1" to enable it. To restrict Inbound traffic you have two options available, first you can use IP restrictions under site\_config to allow/deny addresses and service tags, second you could use a Private Endpoint to enforce private inbound flow - note that you cannot use both of these together, Private Endpoints overide IP restrictions.

## How To Use

### Basic

```
module "las" {
  source                     = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-logic-app-standard?ref=1.0.5"
  environment                = var.environment
  application                = var.application
  resource_group_name        = azurerm_resource_group.resource_group.name
  location                   = var.location
  app_service_plan_id        = module.asp.id
  storage_account_name       = module.storage.storage_name
  storage_account_access_key = module.storage.primary_access_key
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
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | >=0.7, < 1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_logic_app_standard.las](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/logic_app_standard) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [random_string.rnd](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [time_static.t](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_service_plan_id"></a> [app\_service\_plan\_id](#input\_app\_service\_plan\_id) | The ID of the App Service Plan to house this logic app | `string` | n/a | yes |
| <a name="input_app_settings"></a> [app\_settings](#input\_app\_settings) | A map of key-value pairs for App Settings and custom values. There are a number of application settings that will be managed for you by this resource type and shouldn't be configured separately as part of the app\_settings you specify. AzureWebJobsStorage is filled based on storage\_account\_name and storage\_account\_access\_key. WEBSITE\_CONTENTSHARE is detailed above. FUNCTIONS\_EXTENSION\_VERSION is filled based on version. APP\_KIND is set to workflowApp and AzureFunctionsJobHost\_\_extensionBundle\_\_id and AzureFunctionsJobHost\_\_extensionBundle\_\_version are managed by use\_extension\_bundle. Important Default key pairs you MUST seed here: ("WEBSITE\_RUN\_FROM\_PACKAGE" = "", "FUNCTIONS\_WORKER\_RUNTIME" = "node" (or python, etc), "WEBSITE\_NODE\_DEFAULT\_VERSION" = "10.14.1", "APPINSIGHTS\_INSTRUMENTATIONKEY" = "", etc. | `map(string)` | `{}` | no |
| <a name="input_application"></a> [application](#input\_application) | Name of the application | `string` | n/a | yes |
| <a name="input_client_affinity_enabled"></a> [client\_affinity\_enabled](#input\_client\_affinity\_enabled) | Should the logic app send session cookies | `bool` | `true` | no |
| <a name="input_client_certificate_mode"></a> [client\_certificate\_mode](#input\_client\_certificate\_mode) | Should incoming client have to send a certificate? Valid values are 'Optional' and 'Required' | `string` | `"Optional"` | no |
| <a name="input_connection_string"></a> [connection\_string](#input\_connection\_string) | Single element list where the map contains a 'name', 'type' and 'value' fields | `list(map(string))` | `[]` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name. Used as a tag and in naming the resource group | `string` | n/a | yes |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | List of service principal IDs if you want to use a User Assigned Identity over a System Assigned Identity | `list(string)` | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | The region resources will be deployed to | `string` | `"northeurope"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The target resource group this module should be deployed into. If not specified one will be created for you with name like: environment-application-template-location | `string` | `""` | no |
| <a name="input_runtime_version"></a> [runtime\_version](#input\_runtime\_version) | Runtime version of the Logic App, this will auto create the app\_setting FUNCTIONS\_EXTENSION\_VERSION | `string` | `"~3"` | no |
| <a name="input_site_config"></a> [site\_config](#input\_site\_config) | Site config to override site\_config\_defaults. Object structure identical to site\_config\_defaults | `map` | `{}` | no |
| <a name="input_site_config_defaults"></a> [site\_config\_defaults](#input\_site\_config\_defaults) | A site config block for configuring the function | <pre>object({<br>    always_on       = bool<br>    app_scale_limit = number<br>    cors = object({<br>      allowed_origins     = list(string)<br>      support_credentials = bool<br>    })<br>    dotnet_framework_version         = string<br>    elastic_instance_minimum         = number<br>    ftps_state                       = string<br>    health_check_path                = string<br>    http2_enabled                    = bool<br>    linux_fx_version                 = string<br>    min_tls_version                  = string<br>    pre_warmed_instance_count        = number<br>    runtime_scale_monitoring_enabled = bool<br>    use_32_bit_worker_process        = bool<br>    websockets_enabled               = bool<br>    ip_restrictions = object({<br>      ip_addresses = list(object({<br>        name       = string<br>        ip_address = string<br>        priority   = number<br>        action     = string<br>      }))<br>      service_tags = list(object({<br>        name             = string<br>        service_tag_name = string<br>        priority         = number<br>        action           = string<br>      }))<br>      subnet_ids = list(object({<br>        name      = string<br>        subnet_id = string<br>        priority  = number<br>        action    = string<br>      }))<br>    })<br>  })</pre> | <pre>{<br>  "always_on": false,<br>  "app_scale_limit": null,<br>  "cors": {<br>    "allowed_origins": [<br>      "*"<br>    ],<br>    "support_credentials": false<br>  },<br>  "dotnet_framework_version": "v6.0",<br>  "elastic_instance_minimum": null,<br>  "ftps_state": "Disabled",<br>  "health_check_path": null,<br>  "http2_enabled": true,<br>  "ip_restrictions": {<br>    "ip_addresses": [],<br>    "service_tags": [],<br>    "subnet_ids": []<br>  },<br>  "linux_fx_version": null,<br>  "min_tls_version": "1.2",<br>  "pre_warmed_instance_count": null,<br>  "runtime_scale_monitoring_enabled": false,<br>  "use_32_bit_worker_process": false,<br>  "websockets_enabled": true<br>}</pre> | no |
| <a name="input_storage_account_access_key"></a> [storage\_account\_access\_key](#input\_storage\_account\_access\_key) | The key the logic app will use to access storage | `string` | n/a | yes |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | The name of the storage account where the logic app will store its data | `string` | n/a | yes |
| <a name="input_storage_account_share_name"></a> [storage\_account\_share\_name](#input\_storage\_account\_share\_name) | The name of a custom share the logic app will use. If you specify this you should have the Storage module pre-create the share in advance! | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to be applied to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_default_hostname"></a> [default\_hostname](#output\_default\_hostname) | The default hostname of the logic app |
| <a name="output_id"></a> [id](#output\_id) | The ID of the Logic App |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Name of the resource group where resources have been deployed to |
