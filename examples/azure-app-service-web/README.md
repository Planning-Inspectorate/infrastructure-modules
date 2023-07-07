# app-service-plan

Creates an Azure App Service (WebApp)

## How To Use

### Dotnet App Service

```terraform
module "as_dotnet" {
  source              = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-app-service"
  app_service_plan_id = module.asp.id
  environment         = var.environment
  application         = var.application
  location            = var.location
}
```

### Java App Service

```terraform
module "as_java" {
  source              = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-app-service"
  app_service_plan_id = module.asp.id
  environment         = var.environment
  application         = var.application
  location            = var.location
  site_config         = {
    java_version      = "11"
  }
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
| [azurerm_app_service.as](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [random_string.rnd](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [time_static.t](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_service_plan_id"></a> [app\_service\_plan\_id](#input\_app\_service\_plan\_id) | ID of the app service plan instance to host this app service. If unspecified one will be created for you | `any` | `null` | no |
| <a name="input_app_settings"></a> [app\_settings](#input\_app\_settings) | App service plan application settings | `map(string)` | `{}` | no |
| <a name="input_application"></a> [application](#input\_application) | Name of the application | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name. Used as a tag and in naming the resource group | `string` | n/a | yes |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | List of service principal IDs if you want to use a User Assigned Identity over a System Assigned Identity | `list(string)` | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | The region resources will be deployed to | `string` | `"northeurope"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The target resource group this module should be deployed into. If not specified one will be created for you with name like: environment-application-template-location | `string` | `""` | no |
| <a name="input_site_config"></a> [site\_config](#input\_site\_config) | Site config to override site\_config\_defaults. Object structure identical to site\_config\_defaults | `map` | `{}` | no |
| <a name="input_site_config_defaults"></a> [site\_config\_defaults](#input\_site\_config\_defaults) | A site config block for configuring blah | <pre>object({<br>    always_on        = bool<br>    app_command_line = string<br>    cors = object({<br>      allowed_origins     = list(string)<br>      support_credentials = bool<br>    })<br>    default_documents         = list(string)<br>    dotnet_framework_version  = string<br>    ftps_state                = string<br>    health_check_path         = string<br>    http2_enabled             = bool<br>    java_version              = string<br>    java_container            = string<br>    java_container_version    = string<br>    local_mysql_enabled       = string<br>    linux_fx_version          = string<br>    windows_fx_version        = string<br>    managed_pipeline_mode     = string<br>    min_tls_version           = string<br>    php_version               = string<br>    python_version            = string<br>    remote_debugging_enabled  = bool<br>    remote_debugging_version  = string<br>    scm_type                  = string<br>    use_32_bit_worker_process = bool<br>    websockets_enabled        = bool<br>    ip_restrictions = object({<br>      ip_addresses = list(object({<br>        rule_name  = string<br>        ip_address = string<br>        priority   = number<br>        action     = string<br>      }))<br>      service_tags = list(object({<br>        rule_name        = string<br>        service_tag_name = string<br>        priority         = number<br>        action           = string<br>      }))<br>      subnet_ids = list(object({<br>        rule_name = string<br>        subnet_id = string<br>        priority  = number<br>        action    = string<br>      }))<br>    })<br>  })</pre> | <pre>{<br>  "always_on": true,<br>  "app_command_line": null,<br>  "cors": {<br>    "allowed_origins": [<br>      "*"<br>    ],<br>    "support_credentials": false<br>  },<br>  "default_documents": null,<br>  "dotnet_framework_version": "v4.0",<br>  "ftps_state": "Disabled",<br>  "health_check_path": null,<br>  "http2_enabled": true,<br>  "ip_restrictions": {<br>    "ip_addresses": [],<br>    "service_tags": [],<br>    "subnet_ids": []<br>  },<br>  "java_container": null,<br>  "java_container_version": null,<br>  "java_version": null,<br>  "linux_fx_version": null,<br>  "local_mysql_enabled": null,<br>  "managed_pipeline_mode": "Integrated",<br>  "min_tls_version": "1.2",<br>  "php_version": null,<br>  "python_version": null,<br>  "remote_debugging_enabled": false,<br>  "remote_debugging_version": null,<br>  "scm_type": "None",<br>  "use_32_bit_worker_process": false,<br>  "websockets_enabled": true,<br>  "windows_fx_version": null<br>}</pre> | no |
| <a name="input_storage_account"></a> [storage\_account](#input\_storage\_account) | n/a | `list(map(string))` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to be applied to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_service_default_hostname"></a> [app\_service\_default\_hostname](#output\_app\_service\_default\_hostname) | Default hostname of the app service |
| <a name="output_custom_domain_verification_id"></a> [custom\_domain\_verification\_id](#output\_custom\_domain\_verification\_id) | ID of the App Service Custom Domain Verification |
| <a name="output_id"></a> [id](#output\_id) | ID of the App Service |
| <a name="output_identity"></a> [identity](#output\_identity) | Identity block of the app service |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Name of the resource group where resources have been deployed to |
