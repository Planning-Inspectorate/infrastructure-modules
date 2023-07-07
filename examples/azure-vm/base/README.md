Terraform VM Base
=================

Provisions all the base resources needed to stand up a Linux or Windows VM

## Resources Created

* Network Security Group
* Application Security Group
* Network Interface Cards
* Availability set
* Diagnostics storage account (NB: Storage account default action is set to deny. If the serial console or boot diagnostics is required, temporarilly set public network access for the diagnotic storage account to 'Enabled from all networks' and revert back when finished)
* Public IP (optional)

Soft delete will be auto enabled on the storage accounts in production environments. The retention period set for both the container and blobs is 90 days.

## How To Update this README.md

* terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_central_nsg_rules"></a> [central\_nsg\_rules](#module\_central\_nsg\_rules) | git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-network-security-group-rules | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_application_security_group.application_security_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_security_group) | resource |
| [azurerm_availability_set.availability_set](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/availability_set) | resource |
| [azurerm_network_interface.network_interface](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface_application_security_group_association.nic_asg_assoc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_application_security_group_association) | resource |
| [azurerm_network_interface_backend_address_pool_association.backend_address_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_backend_address_pool_association) | resource |
| [azurerm_network_interface_security_group_association.nic_nsg_assoc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association) | resource |
| [azurerm_network_security_group.network_security_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_public_ip.public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_storage_account.storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_account_network_rules.storage-network-rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_network_rules) | resource |
| [random_string.storage_account_name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [azurerm_storage_account.storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_asg_name_override"></a> [asg\_name\_override](#input\_asg\_name\_override) | Used to force the application security group to use the name (false) or the resource\_group\_name (true). Values can be true/false | `bool` | `false` | no |
| <a name="input_enable_accelerated_networking"></a> [enable\_accelerated\_networking](#input\_enable\_accelerated\_networking) | n/a | `string` | `false` | no |
| <a name="input_enable_backend_pool_association"></a> [enable\_backend\_pool\_association](#input\_enable\_backend\_pool\_association) | Control variable for the backend address pool association in the NIC. Set to true if the VM will be attached to a Load Balancer. | `bool` | `false` | no |
| <a name="input_enable_https_traffic_only"></a> [enable\_https\_traffic\_only](#input\_enable\_https\_traffic\_only) | n/a | `bool` | `true` | no |
| <a name="input_enable_ip_forwarding"></a> [enable\_ip\_forwarding](#input\_enable\_ip\_forwarding) | n/a | `string` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name. Used as a tag and in naming the resource group | `string` | n/a | yes |
| <a name="input_existing_storage_account_name"></a> [existing\_storage\_account\_name](#input\_existing\_storage\_account\_name) | This will make the module use and existing storage account | `string` | `""` | no |
| <a name="input_existing_storage_account_rg_name"></a> [existing\_storage\_account\_rg\_name](#input\_existing\_storage\_account\_rg\_name) | This will make the module look for an existing storage account on this resource group | `string` | `""` | no |
| <a name="input_load_balancer_backend_address_pools_ids"></a> [load\_balancer\_backend\_address\_pools\_ids](#input\_load\_balancer\_backend\_address\_pools\_ids) | List of string of the resource IDs for the load balancer backend address pools | `list(string)` | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region to deploy to | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name for all resources | `string` | n/a | yes |
| <a name="input_network_default_action"></a> [network\_default\_action](#input\_network\_default\_action) | If a source IPs fails to match a rule should it be allowed for denied | `string` | `"Deny"` | no |
| <a name="input_network_interface_ip_configuration_name"></a> [network\_interface\_ip\_configuration\_name](#input\_network\_interface\_ip\_configuration\_name) | Name for the IP Configuration attached to the Network Interface created for the Virtual Machine. If default value is not changed it will match the VM name. | `string` | `"Default"` | no |
| <a name="input_network_rule_ips"></a> [network\_rule\_ips](#input\_network\_rule\_ips) | List of public IPs that are allowed to access the storage account. Private IPs in RFC1918 are not allowed here | `list(string)` | `[]` | no |
| <a name="input_network_rule_virtual_network_subnet_ids"></a> [network\_rule\_virtual\_network\_subnet\_ids](#input\_network\_rule\_virtual\_network\_subnet\_ids) | List of subnet IDs which are allowed to access the storage account | `list(string)` | `[]` | no |
| <a name="input_network_rule_virtual_network_subnet_ids_include_cicd_agents"></a> [network\_rule\_virtual\_network\_subnet\_ids\_include\_cicd\_agents](#input\_network\_rule\_virtual\_network\_subnet\_ids\_include\_cicd\_agents) | A boolean switch to allow for scenarios where the default set of cicd subnets (containing for example Bamboo/ADO agents) should not be added to the storage accounts network rules. An example would be a storage accounts used as a cloud witness for a windows failover cluster that exists outside of the paired regions of the cluster nodes | `bool` | `true` | no |
| <a name="input_network_security_group_id"></a> [network\_security\_group\_id](#input\_network\_security\_group\_id) | Associate Network Security Group ID with VM | `list(string)` | `[]` | no |
| <a name="input_platform_fault_domain_count"></a> [platform\_fault\_domain\_count](#input\_platform\_fault\_domain\_count) | Availability set platform fault domain count | `string` | `"3"` | no |
| <a name="input_platform_update_domain_count"></a> [platform\_update\_domain\_count](#input\_platform\_update\_domain\_count) | Availability set platform update domain count | `string` | `"5"` | no |
| <a name="input_public_ip_address_allocation"></a> [public\_ip\_address\_allocation](#input\_public\_ip\_address\_allocation) | Public IP to allocate to each NIC. Dynamic, Static or None | `string` | `"None"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource group to deploy to | `string` | n/a | yes |
| <a name="input_storage_soft_delete_retention_policy"></a> [storage\_soft\_delete\_retention\_policy](#input\_storage\_soft\_delete\_retention\_policy) | Is soft delete enabled for containers and blobs? | `bool` | `false` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Target subnet to find IPs for NIC assigment | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_vm_count"></a> [vm\_count](#input\_vm\_count) | n/a | `number` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_application_security_group_id"></a> [application\_security\_group\_id](#output\_application\_security\_group\_id) | n/a |
| <a name="output_availability_set_id"></a> [availability\_set\_id](#output\_availability\_set\_id) | n/a |
| <a name="output_network_interface_ids"></a> [network\_interface\_ids](#output\_network\_interface\_ids) | n/a |
| <a name="output_network_interface_ips"></a> [network\_interface\_ips](#output\_network\_interface\_ips) | n/a |
| <a name="output_network_security_group_id"></a> [network\_security\_group\_id](#output\_network\_security\_group\_id) | n/a |
| <a name="output_network_security_group_name"></a> [network\_security\_group\_name](#output\_network\_security\_group\_name) | n/a |
| <a name="output_public_ip_ids"></a> [public\_ip\_ids](#output\_public\_ip\_ids) | n/a |
| <a name="output_public_ip_names"></a> [public\_ip\_names](#output\_public\_ip\_names) | n/a |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | n/a |
| <a name="output_storage_id"></a> [storage\_id](#output\_storage\_id) | n/a |
| <a name="output_storage_name"></a> [storage\_name](#output\_storage\_name) | n/a |
| <a name="output_storage_uri"></a> [storage\_uri](#output\_storage\_uri) | n/a |
