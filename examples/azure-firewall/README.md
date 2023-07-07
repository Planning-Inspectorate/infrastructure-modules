# azure-firewall

This module deploys an Azure Firewall. They need no more than a /26 address space to function and the Firewall must be in the same resource group as the corresponding subnet.

## How To Use

Include example code snippets:

### Example

```terraform
module "fw" {
  source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-firewall"
  resource_group_name = var.vnet_rg
  environment = var.environment
  application = var.application
  location    = var.location
  subnet_id   = data.azurerm_subnet.fw.id
  tags        = var.tags
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
| [azurerm_firewall.fw](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall) | resource |
| [azurerm_public_ip.pip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [time_static.t](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Name of the application | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name. Used as a tag and in naming the resource group | `string` | n/a | yes |
| <a name="input_firewall_policy_id"></a> [firewall\_policy\_id](#input\_firewall\_policy\_id) | The ID of a firewall policy that should be attached to this firewall | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The region resources will be deployed to | `string` | `"northeurope"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group to deploy the Azure Firewall into. It must also contain the vnet and subnet | `string` | n/a | yes |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | Possible values are AZFW\_Hub and AZFW\_VNet | `string` | `"AZFW_VNet"` | no |
| <a name="input_sku_tier"></a> [sku\_tier](#input\_sku\_tier) | Tier of the firewall | `string` | `"Standard"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The subnet ID from which the firewall will receive a private IP | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to be applied to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_firewall_id"></a> [firewall\_id](#output\_firewall\_id) | The ID of the firewall |
| <a name="output_pip_id"></a> [pip\_id](#output\_pip\_id) | The ID of the public IP |
