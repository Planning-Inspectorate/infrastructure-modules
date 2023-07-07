# azure-analysis-services

Provisions a Analysis Services Server

## How To Use

* Inputs should be refereced in a module to create your Analysis Services Server of the sort: `module "azure_analysis_services" {...}`

```HCL

module "azure_analysis_services" {
  source                  = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-analysis-services"
  environment             = var.environment
  application             = var.application
  location                = var.location
  sku                     = var.sku
  admin_users             = var.admin_users
  enable_power_bi_service = true

  ipv4_firewall_rule {
    name        = "myRule1"
    range_start = "210.117.252.0"
    range_end   = "210.117.252.255"
  }

  tags                    = "${var.tags}"
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
| [azurerm_analysis_services_server.analysis_services_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/analysis_services_server) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [time_static.t](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_users"></a> [admin\_users](#input\_admin\_users) | List of email addresses of admin users | `list(string)` | `[]` | no |
| <a name="input_application"></a> [application](#input\_application) | Name of the application | `string` | n/a | yes |
| <a name="input_enable_power_bi_service"></a> [enable\_power\_bi\_service](#input\_enable\_power\_bi\_service) | Indicates if the Power BI service is allowed to access or not | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name. Used as a tag and in naming the resource group | `string` | n/a | yes |
| <a name="input_ipv4_firewall_rules"></a> [ipv4\_firewall\_rules](#input\_ipv4\_firewall\_rules) | "One or more ipv4\_firewall\_rule block(s) as defined below:<br>[<br>  {<br>    name        = "myRule1"<br>    range\_start = "210.117.252.0"<br>    range\_end   = "210.117.252.255"<br>  }<br>]" | `list(map(string))` | `[]` | no |
| <a name="input_ipv4_firewall_rules_include_cicd_agents"></a> [ipv4\_firewall\_rules\_include\_cicd\_agents](#input\_ipv4\_firewall\_rules\_include\_cicd\_agents) | A boolean switch to allow for scenarios where the default set of cicd subnets (containing for example Bamboo/ADO agents) should not be added to the ipv4 firewall rules. | `bool` | `true` | no |
| <a name="input_location"></a> [location](#input\_location) | The region resources will be deployed to | `string` | `"northeurope"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The target resource group this module should be deployed into. If not specified one will be created for you with name like: environment-application-template-location | `string` | `""` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | SKU for the Analysis Services Server. Possible values are: D1, B1, B2, S0, S1, S2, S4, S8, S9, S8v2 and S9v2 | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to be applied to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_analysis_services_server_id"></a> [analysis\_services\_server\_id](#output\_analysis\_services\_server\_id) | The ID of the Analysis Services Server |
| <a name="output_analysis_services_server_name"></a> [analysis\_services\_server\_name](#output\_analysis\_services\_server\_name) | The full name of the Analysis Services Server |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Name of the resource group where resources have been deployed to |
