# azure-network-security-group

CI for NSG

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
| <a name="module_nsg"></a> [nsg](#module\_nsg) | ../../azure-network-security-group | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Name of the application | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name. Used as a tag and in naming the resource group | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The region resources will be deployed to | `string` | `"northeurope"` | no |
| <a name="input_nsg_in_rules"></a> [nsg\_in\_rules](#input\_nsg\_in\_rules) | "A Map of inbound NSG rules. Example format:<br>azure-https = {<br>  access                      = "Allow"<br>  priority                    = 300<br>  protocol                    = "Tcp"<br>  source\_port\_ranges          = ["0-4000", "4777"]<br>  source\_address\_prefix       = "172.0.0.0/8"<br>  destination\_port\_ranges     = ["443", "8443"]<br>  destinaation\_address\_prefix = "*"<br>}" | `map` | `{}` | no |
| <a name="input_nsg_out_rules"></a> [nsg\_out\_rules](#input\_nsg\_out\_rules) | "A Map of outound NSG rules. Example format:<br>azure-https = {<br>  access                       = "Allow"<br>  priority                     = 300<br>  protocol                     = "Tcp"<br>  source\_port\_range            = "*"<br>  source\_address\_prefix        = "172.0.0.0/8"<br>  destination\_port\_ranges      = ["443", "8443"]<br>  destination\_address\_prefixes = ["167.87.99.100"]<br>}" | `map` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to be applied to resources | `map(string)` | `{}` | no |

## Outputs

No outputs.
