# azure-app-service-plan

This directory contains code that will deploy an Azure App Service Plan which can be used for Web Apps, Function Apps and the Standard Logic App

## How To Use

### Default Deployment

```terraform
module "tempalte" {
  source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-app-service-plan"
  environment = "dev"
  application = "app"
  location    = "northeurope"
  tags        = local.tags
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
| [azurerm_app_service_plan.asp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_plan) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [time_static.t](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_service_env_id"></a> [app\_service\_env\_id](#input\_app\_service\_env\_id) | ASE where the ASP should be located | `string` | `null` | no |
| <a name="input_application"></a> [application](#input\_application) | Name of the application | `string` | n/a | yes |
| <a name="input_elastic_worker_count"></a> [elastic\_worker\_count](#input\_elastic\_worker\_count) | Maximum number of workers for an Elastic sclaed App Service Plan | `string` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name. Used as a tag and in naming the resource group | `string` | n/a | yes |
| <a name="input_kind"></a> [kind](#input\_kind) | Kind of app service plan, Wndows, Linux or elastic | `string` | `"Linux"` | no |
| <a name="input_location"></a> [location](#input\_location) | The region resources will be deployed to | `string` | `"northeurope"` | no |
| <a name="input_reserved"></a> [reserved](#input\_reserved) | Is this app service plan reserved, must be true for 'Kind' Linux and false for Windows/App | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The target resource group this module should be deployed into. If not specified one will be created for you with name like: environment-application-template-location | `string` | `""` | no |
| <a name="input_site_scaling"></a> [site\_scaling](#input\_site\_scaling) | Can apps independently scale with this ASP? | `bool` | `false` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | The Sku of the ASP | `map(string)` | <pre>{<br>  "capacity": "1",<br>  "size": "S1",<br>  "tier": "Standard"<br>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to be applied to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the App Service Plan. |
| <a name="output_name"></a> [name](#output\_name) | The nsame of the ASP |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Name of the resource group where resources have been deployed to |
