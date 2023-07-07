# azure-network-security-group-rules

This directory creates a number of central rules that are to be deployed to every Terraform NSG deployment.

Rules updated 27/04/2022 to include Satellite

## How To Use

Unusually, this module is not intended to be deployed independently of the main azure-network-security-group module but instead is referenced by that module.

The reason this module is separate is the intention is for this module to be non-tagged so changes to the rules are reflected regardless of tagged version of NSG module.

Please note: This may mean that changes are required in Terraform even when nothing has changed in code (as the rules have changed)

## How To Update this README.md

* terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2, < 4 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >=0.7, < 1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 2, < 4 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_network_security_rule.nsg_in](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.nsg_out](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_network_security_group_name"></a> [network\_security\_group\_name](#input\_network\_security\_group\_name) | The target Network Security Group | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The target Resource Group the Network Security Groups exists in | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nsg_in_rules"></a> [nsg\_in\_rules](#output\_nsg\_in\_rules) | Formatted list of default and user defined NSG rules |
| <a name="output_nsg_out_rules"></a> [nsg\_out\_rules](#output\_nsg\_out\_rules) | Formatted list of default and user defined NSG rules |
