# azure-firewall-policy

CI for Azure Firewall Policy

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
| <a name="module_fwp"></a> [fwp](#module\_fwp) | ../../azure-firewall-policy | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Name of the application | `string` | n/a | yes |
| <a name="input_application_rules"></a> [application\_rules](#input\_application\_rules) | Complex map of application based rules | `any` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name. Used as a tag and in naming the resource group | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The region resources will be deployed to | `string` | `"northeurope"` | no |
| <a name="input_nat_rules"></a> [nat\_rules](#input\_nat\_rules) | Complex map of nat based rules. Note: if invalid attachment to firewall will fail | `any` | n/a | yes |
| <a name="input_network_rules"></a> [network\_rules](#input\_network\_rules) | Complex map of network based rules | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to be applied to resources | `map(string)` | `{}` | no |
| <a name="input_vnet_rg"></a> [vnet\_rg](#input\_vnet\_rg) | The resource group that holds the vnet | `string` | n/a | yes |

## Outputs

No outputs.
