# azure-bastion

Provisions a Bastion PaaS service for a desired VNET

## How To Use

* Inputs should be refereced in a module to create your bastion of the sort:

```
module "bastion" {
  source = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-bastion"
  environment              = var.environment
  application              = var.application
  location                 = var.location
  service_name_environment = var.service_name_environment
  service_name_business    = var.service_name_business
  vnet                     = var.vnet
  vnet_resource_group_name = var.vnet_resource_group_name
  subnet_cidr              = var.subnet_cidr
  tags                     = var.tags
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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_server_name"></a> [server\_name](#module\_server\_name) | ../azure-vm/server-identification | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_bastion_host.bastion](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/bastion_host) | resource |
| [azurerm_public_ip.bastion_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group.resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_subnet.bastion_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [time_static.t](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Name of the application | `string` | `"devops"` | no |
| <a name="input_component"></a> [component](#input\_component) | Used to construct the resource group name | `string` | `"bastion"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Used to construct the resource group name | `any` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure region to deploy to | `any` | n/a | yes |
| <a name="input_service_name_business"></a> [service\_name\_business](#input\_service\_name\_business) | Used to construct the name of the bastion resource. eg 'us' | `any` | n/a | yes |
| <a name="input_service_name_environment"></a> [service\_name\_environment](#input\_service\_name\_environment) | Used to construct the name of the bastion resource. eg 'dev'/'prod' | `any` | n/a | yes |
| <a name="input_service_name_service"></a> [service\_name\_service](#input\_service\_name\_service) | Used to construct the name of the bastion resource | `string` | `"infrastructure"` | no |
| <a name="input_subnet_cidr"></a> [subnet\_cidr](#input\_subnet\_cidr) | The subnet CIDR size of bastion subnet. Minimum CIDR /27 | `list(string)` | <pre>[<br>  "AzureBastionSubnet"<br>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_vnet"></a> [vnet](#input\_vnet) | The virtual network where bastion is provisoned | `any` | n/a | yes |
| <a name="input_vnet_resource_group_name"></a> [vnet\_resource\_group\_name](#input\_vnet\_resource\_group\_name) | The name of the resource group housing the virtual network | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name"></a> [name](#output\_name) | Name of the bastion |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Name of the resource group where resources have been deployed to |
