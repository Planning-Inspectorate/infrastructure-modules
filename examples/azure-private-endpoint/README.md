# azure-private-endpoint

This directory contains code that is used to create a private endpoint to connect a supported resource type
to a subnet in an Azure virtual network for private conenctivity.
It is designed to support the following standards and conventions

* Terraform configuration files (e.g. data.tf for terraform data elements, output.tf for output variables). Note that this template cannot cater for every kind of resource that may be described by Terraform. There is obviously some discretion on the part of the engineer to use meaningful names for these files.
* Use of terratest on build agent to run CI tests for the module
* Local terraform deployments with native terraform commands and authentication to azure using az login (i.e. as yourself, which makes sense)
* Use of terraform-docs as standard

## How To Use

Example code snippet (endpoint for a blob storage account):

```terraform
module "private_endpoint" {
  source                              = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-private-endpoint"
  environment                         = "dev"
  application                         = "my-own-private-endpoint"
  location                            = "northeurope"
  private_dns_zone_id                 = data.azurerm_private_dns_zone.zone.id
  private_connection_resource_id      = "/subscriptions/bab9ed05-2c6e-4631-a0cf-7373c33838cc/resourceGroups/ci-splunkdeploy-vm-westeurope/providers/Microsoft.Storage/storageAccounts/0zbyo2rw4vto7ihcq4z70rf9"
  subresource_names                   = ["blob"]
  subnet_name                         = "sandbox"
  virtual_network_name                = "subscription-vnet-northeurope"
  virtual_network_resource_group_name = "subscription-vnet-northeurope"
}
```
See the Microsoft doc at https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-overview#private-link-resource for more information about the allowed subresource names.
See wiki page for more information: https://hiscox.atlassian.net/wiki/spaces/TPC/pages/646709562

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
| [azurerm_private_endpoint.pe](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [time_static.t](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Name of the application | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name. Used as a tag and in naming the resource group | `string` | n/a | yes |
| <a name="input_label"></a> [label](#input\_label) | An optional label to distibuish multiple private endpoint instances defined in the same config | `string` | `""` | no |
| <a name="input_location"></a> [location](#input\_location) | The region resources will be deployed to | `string` | `"northeurope"` | no |
| <a name="input_private_connection_resource_id"></a> [private\_connection\_resource\_id](#input\_private\_connection\_resource\_id) | The ID of the remote resource for the private endpoint | `string` | n/a | yes |
| <a name="input_private_dns_zone_id"></a> [private\_dns\_zone\_id](#input\_private\_dns\_zone\_id) | ID of the zone | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The target resource group this module should be deployed into. If not specified one will be created for you with name like: environment-application-template-location | `string` | `""` | no |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | n/a | `any` | n/a | yes |
| <a name="input_subresource_names"></a> [subresource\_names](#input\_subresource\_names) | A list (only one list item is allowed) containing the allowed subresource names a private endpoint connection may connect to eg "blob", "sqlServer", "vault" etc | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to be applied to resources | `map(string)` | `{}` | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | n/a | `any` | n/a | yes |
| <a name="input_virtual_network_resource_group_name"></a> [virtual\_network\_resource\_group\_name](#input\_virtual\_network\_resource\_group\_name) | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_endpoint"></a> [private\_endpoint](#output\_private\_endpoint) | The details of the created private endpoint resource |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Name of the resource group where resources have been deployed to |
