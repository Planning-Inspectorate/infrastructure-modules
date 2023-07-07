# network-flow-nsg

An example of applying the network flow nsg logs to a sample vm/subnet to capture traffic.

Note: This example includes a separate rule base that lists all the BUs current VNET ranges.

This will need to be updated with any new VNETS added by any BUs, but does incldue a Hiscox catch-all group

## How To Update this README.md

* terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`

## Diagrams

![image info](./diagrams/design.png)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 2 |
| <a name="requirement_time"></a> [time](#requirement\_time) | ~>0.7 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 2 |
| <a name="provider_time"></a> [time](#provider\_time) | ~>0.7 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_flow_log"></a> [flow\_log](#module\_flow\_log) | ../../azure-network-watcher-flow-log | n/a |
| <a name="module_law"></a> [law](#module\_law) | ../../azure-log-analytics | n/a |
| <a name="module_lb-int"></a> [lb-int](#module\_lb-int) | ../../azure-load-balancer | n/a |
| <a name="module_nsg"></a> [nsg](#module\_nsg) | ../../azure-network-security-group | n/a |
| <a name="module_storage"></a> [storage](#module\_storage) | ../../azure-storage-account | n/a |
| <a name="module_subnet"></a> [subnet](#module\_subnet) | ../../azure-subnet | n/a |
| <a name="module_vm"></a> [vm](#module\_vm) | ../../azure-vm | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_network_security_rule.nsg_in](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.nsg_rule_permit_lb_vms_ssh](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_resource_group.resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [time_static.t](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |
| [azurerm_key_vault.kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.admin_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_network_watcher.network_watcher](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/network_watcher) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_prefixes"></a> [address\_prefixes](#input\_address\_prefixes) | IP address range for subnet | `string` | n/a | yes |
| <a name="input_analytics"></a> [analytics](#input\_analytics) | Check whether the log analytics element of the flow logs is deployed | `bool` | `true` | no |
| <a name="input_application"></a> [application](#input\_application) | Name of the application | `string` | n/a | yes |
| <a name="input_business"></a> [business](#input\_business) | Business unit which owns the infrastructure | `string` | n/a | yes |
| <a name="input_disk_os_size_linux"></a> [disk\_os\_size\_linux](#input\_disk\_os\_size\_linux) | Size of linux os disk in GB | `string` | `"64"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name. Used as a tag and in naming the resource group | `string` | n/a | yes |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | Name of the key vault, used to retrieve VM admin password | `string` | n/a | yes |
| <a name="input_key_vault_rg"></a> [key\_vault\_rg](#input\_key\_vault\_rg) | Resource group that contains key vault | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The region resources will be deployed to | `string` | `"northeurope"` | no |
| <a name="input_network_watcher_name"></a> [network\_watcher\_name](#input\_network\_watcher\_name) | Name of network watcher | `string` | n/a | yes |
| <a name="input_network_watcher_resource_group_name"></a> [network\_watcher\_resource\_group\_name](#input\_network\_watcher\_resource\_group\_name) | Resource Group for network watcher | `string` | n/a | yes |
| <a name="input_nsg_in_rules"></a> [nsg\_in\_rules](#input\_nsg\_in\_rules) | A Map of inbound NSG rules | `map` | `{}` | no |
| <a name="input_nsg_out_rules"></a> [nsg\_out\_rules](#input\_nsg\_out\_rules) | A Map of outound NSG rules | `map` | `{}` | no |
| <a name="input_reporting_interval"></a> [reporting\_interval](#input\_reporting\_interval) | Frequency of updates to logs. Acceptable values are 60 or 10 (minutes) | `string` | `"60"` | no |
| <a name="input_server_environment"></a> [server\_environment](#input\_server\_environment) | Used to generate the name of servers based on the server-identification standard | `string` | n/a | yes |
| <a name="input_service"></a> [service](#input\_service) | Type of  infrastructure | `string` | n/a | yes |
| <a name="input_source_image_reference"></a> [source\_image\_reference](#input\_source\_image\_reference) | n/a | `map(string)` | <pre>{<br>  "offer": "RHEL",<br>  "publisher": "RedHat",<br>  "sku": "7-LVM",<br>  "version": "latest"<br>}</pre> | no |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | New Subnet Name | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to be applied to resources | `map(string)` | `{}` | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | Vnet name for new subnet | `string` | n/a | yes |
| <a name="input_virtual_network_resource_group_name"></a> [virtual\_network\_resource\_group\_name](#input\_virtual\_network\_resource\_group\_name) | Resource Group for Vnet | `string` | n/a | yes |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | The size of VM ot provision | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Name of the resource group where resources have been deployed to |
