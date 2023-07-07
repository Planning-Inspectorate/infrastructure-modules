# azure-sql-managed-instance

This creates a managed SQL instance and should be invoked as a sub-module like:

```terraform
module "sql_managed" {
  source = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azuresql-managed"
  ...
  _other required params_
  ...
}
```

It requires a subnet with appropriate service delegation, Network Security Group and Route Table
to deploy the Managed Instance into.

## How To Update this README.md

* terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* Follow the setup instructions here: [terraform-docs](https://github.com/segmentio/terraform-docs)
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
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_template_deployment.sqlmi](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/template_deployment) | resource |
| [time_static.t](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Name of the application | `string` | n/a | yes |
| <a name="input_cores"></a> [cores](#input\_cores) | Number of vCores available to this instance | `string` | `"16"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name. Used as a tag and in naming the resource group | `string` | n/a | yes |
| <a name="input_hardware_family"></a> [hardware\_family](#input\_hardware\_family) | Hardware family for underlying server VM | `string` | `"Gen5"` | no |
| <a name="input_license"></a> [license](#input\_license) | Type, can be either: LicenseIncluded, BasePrice | `string` | `"LicenseIncluded"` | no |
| <a name="input_location"></a> [location](#input\_location) | The region resources will be deployed to | `string` | `"northeurope"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The target resource group this module should be deployed into. If not specified one will be created for you with name like: environment-application-template-location | `string` | `""` | no |
| <a name="input_sku_edition"></a> [sku\_edition](#input\_sku\_edition) | Use case | `string` | `"GeneralPurpose"` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | Name of the Sku | `string` | `"GP_Gen5"` | no |
| <a name="input_sql_password"></a> [sql\_password](#input\_sql\_password) | Password for the SQL admin user | `any` | n/a | yes |
| <a name="input_storage_size"></a> [storage\_size](#input\_storage\_size) | Storage avaialble to this instance | `string` | `"32"` | no |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | The name of the dedicated SQLMI subnet | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to be applied to resources | `map(string)` | `{}` | no |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | The Virtual Network that contains the SQL MI specific subnet | `any` | n/a | yes |
| <a name="input_vnet_resource_group"></a> [vnet\_resource\_group](#input\_vnet\_resource\_group) | The resource group that contains the Virtual Network | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_fqdn"></a> [fqdn](#output\_fqdn) | The fully qualified domain name of the provisioned Managed Instance |
| <a name="output_name"></a> [name](#output\_name) | Name of the managed instance that was created |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Name of the resource group where resources have been deployed to |
