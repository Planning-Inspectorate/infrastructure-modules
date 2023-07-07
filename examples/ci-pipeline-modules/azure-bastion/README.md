# azure-bastion

CI for bastion

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
| <a name="module_bastion"></a> [bastion](#module\_bastion) | ../../azure-bastion | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Name of the application | `string` | `"devops"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Used to construct the resource group name | `any` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure region to deploy to | `any` | n/a | yes |
| <a name="input_service_name_business"></a> [service\_name\_business](#input\_service\_name\_business) | Used to construct the name of the bastion resource. eg 'us' | `any` | n/a | yes |
| <a name="input_service_name_environment"></a> [service\_name\_environment](#input\_service\_name\_environment) | Used to construct the name of the bastion resource. eg 'dev'/'prod' | `any` | n/a | yes |
| <a name="input_subnet_cidr"></a> [subnet\_cidr](#input\_subnet\_cidr) | The subnet CIDR size of bastion subnet. Minimum CIDR /27 | `list` | <pre>[<br>  "AzureBastionSubnet"<br>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_vnet"></a> [vnet](#input\_vnet) | The virtual network where bastion is provisoned | `any` | n/a | yes |
| <a name="input_vnet_resource_group_name"></a> [vnet\_resource\_group\_name](#input\_vnet\_resource\_group\_name) | The name of the resource group housing the virtual network | `any` | n/a | yes |

## Outputs

No outputs.
