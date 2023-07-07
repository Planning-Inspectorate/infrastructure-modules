# azure-vm

CI for VMs

## How To Update this README.md

* terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 2 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3 |

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ade_key_vault_id"></a> [ade\_key\_vault\_id](#input\_ade\_key\_vault\_id) | ID of the key vault to be used for Azure Disk Encryption | `string` | `""` | no |
| <a name="input_ade_key_vault_uri"></a> [ade\_key\_vault\_uri](#input\_ade\_key\_vault\_uri) | URI of the key vault to be used for Azure Disk Encryption | `string` | `""` | no |
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | Admin password for the host | `string` | n/a | yes |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | Admin username for the host | `string` | `"azureuser"` | no |
| <a name="input_application"></a> [application](#input\_application) | Name of the application | `string` | n/a | yes |
| <a name="input_asg_name_override"></a> [asg\_name\_override](#input\_asg\_name\_override) | Used to force the application security group to use the name (false) or the resource\_group\_name (true). Values can be true/false | `bool` | `false` | no |
| <a name="input_bitbucket_password"></a> [bitbucket\_password](#input\_bitbucket\_password) | n/a | `string` | `"bitbucket_password"` | no |
| <a name="input_bitbucket_team"></a> [bitbucket\_team](#input\_bitbucket\_team) | n/a | `string` | `"bitbucket_team"` | no |
| <a name="input_bitbucket_username"></a> [bitbucket\_username](#input\_bitbucket\_username) | n/a | `string` | `"bitbucket_username"` | no |
| <a name="input_business"></a> [business](#input\_business) | The name of the business unit this resource belongs to. One of: it\_services, us, uk, europe, london\_market, group, hiscox\_re | `string` | n/a | yes |
| <a name="input_control_repo_name"></a> [control\_repo\_name](#input\_control\_repo\_name) | n/a | `string` | `"control_repo_name"` | no |
| <a name="input_data_disk"></a> [data\_disk](#input\_data\_disk) | Example: data\_disk = [<br>      {<br>        drive\_letter         = "e"<br>        label                = "data"<br>        disk\_luns            = [0,1,2,3]<br>        interleave           = 65536<br>        allocation\_unit\_size = 65536<br>      },<br>      {<br>        drive\_letter         = "f"<br>        label                = "logs"<br>        disk\_luns            = [4]<br>        interleave           = null<br>        allocation\_unit\_size = 4096<br>      },<br>      {<br>        drive\_letter         = "t"<br>        label                = "backup"<br>        disk\_luns            = [5,6]<br>        interleave           = 65536<br>        allocation\_unit\_size = 65536<br>    }<br>  ] | `list(object({ drive_letter = string, label = string, disk_luns = list(number), interleave = number, allocation_unit_size = number }))` | `[]` | no |
| <a name="input_disk_caching_linux"></a> [disk\_caching\_linux](#input\_disk\_caching\_linux) | Option to enable disk caching. Valid values: None, ReadOnly and ReadWrite | `list(string)` | `[]` | no |
| <a name="input_disk_caching_windows"></a> [disk\_caching\_windows](#input\_disk\_caching\_windows) | Option to enable disk caching. Valid values: None, ReadOnly and ReadWrite | `list(string)` | `[]` | no |
| <a name="input_disk_count_linux"></a> [disk\_count\_linux](#input\_disk\_count\_linux) | Number of additional disks to create | `number` | `0` | no |
| <a name="input_disk_count_windows"></a> [disk\_count\_windows](#input\_disk\_count\_windows) | Number of additional disks to create | `number` | `0` | no |
| <a name="input_disk_format_suffix"></a> [disk\_format\_suffix](#input\_disk\_format\_suffix) | number format option for disk suffix | `string` | `"%02d"` | no |
| <a name="input_disk_os_size_linux"></a> [disk\_os\_size\_linux](#input\_disk\_os\_size\_linux) | Size of linux os disk in GB | `string` | `"32"` | no |
| <a name="input_disk_os_size_windows"></a> [disk\_os\_size\_windows](#input\_disk\_os\_size\_windows) | Size of windows os disk in GB | `string` | `"127"` | no |
| <a name="input_disk_server_identity_override"></a> [disk\_server\_identity\_override](#input\_disk\_server\_identity\_override) | Used to force the disks to use server-identification for name (true) instead of local.name (false). Values can be true/false | `bool` | `false` | no |
| <a name="input_disk_sizes_linux"></a> [disk\_sizes\_linux](#input\_disk\_sizes\_linux) | Size of additional disks in GB | `list(string)` | `[]` | no |
| <a name="input_disk_sizes_windows"></a> [disk\_sizes\_windows](#input\_disk\_sizes\_windows) | Size of additional disks in GB | `list(string)` | `[]` | no |
| <a name="input_disk_skus_linux"></a> [disk\_skus\_linux](#input\_disk\_skus\_linux) | SKU of the additional disks. Valid values: Standard\_LRS, Premium\_LRS, StandardSSD\_LRS or UltraSSD\_LRS | `list(string)` | `[]` | no |
| <a name="input_disk_skus_windows"></a> [disk\_skus\_windows](#input\_disk\_skus\_windows) | SKU of the additional disks. Valid values: Standard\_LRS, Premium\_LRS, StandardSSD\_LRS or UltraSSD\_LRS | `list(string)` | `[]` | no |
| <a name="input_dns_suffix"></a> [dns\_suffix](#input\_dns\_suffix) | n/a | `string` | `"azure.hiscox.com"` | no |
| <a name="input_enable_backend_pool_association"></a> [enable\_backend\_pool\_association](#input\_enable\_backend\_pool\_association) | n/a | `bool` | `false` | no |
| <a name="input_encryption_at_host_enabled"></a> [encryption\_at\_host\_enabled](#input\_encryption\_at\_host\_enabled) | Should all of the disks (including the temp disk) attached to this Virtual Machine be encrypted. Values can be true/false | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name. Used as a tag and in naming the resource group | `string` | n/a | yes |
| <a name="input_init_scripts"></a> [init\_scripts](#input\_init\_scripts) | Names of scripts to be rendered and executed as part of VM provisioning | `list(string)` | <pre>[<br>  "puppet_agent"<br>]</pre> | no |
| <a name="input_load_balancer_backend_address_pools_ids"></a> [load\_balancer\_backend\_address\_pools\_ids](#input\_load\_balancer\_backend\_address\_pools\_ids) | List of resource IDs of azure load balancer backend pools to which NICs should be added | `list(string)` | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | The region resources will be deployed to | `string` | `"northeurope"` | no |
| <a name="input_network_interface_ip_configuration_name"></a> [network\_interface\_ip\_configuration\_name](#input\_network\_interface\_ip\_configuration\_name) | Name for the IP Configuration attached to the Network Interface created for the Virtual Machine. If default value is not changed it will match the VM name. | `string` | `"Default"` | no |
| <a name="input_network_security_group_id"></a> [network\_security\_group\_id](#input\_network\_security\_group\_id) | Associate Network Security Group ID with VM | `list(string)` | `[]` | no |
| <a name="input_patching"></a> [patching](#input\_patching) | Custom patching tag | `string` | `"auto"` | no |
| <a name="input_pe_agent_specified_environment"></a> [pe\_agent\_specified\_environment](#input\_pe\_agent\_specified\_environment) | n/a | `string` | `"production"` | no |
| <a name="input_pe_console_admin_password"></a> [pe\_console\_admin\_password](#input\_pe\_console\_admin\_password) | n/a | `string` | `"pe_console_admin_password"` | no |
| <a name="input_pe_console_url"></a> [pe\_console\_url](#input\_pe\_console\_url) | n/a | `string` | `"pe_console_url"` | no |
| <a name="input_pe_deploy_key_label"></a> [pe\_deploy\_key\_label](#input\_pe\_deploy\_key\_label) | n/a | `string` | `"pe_deploy_key_label"` | no |
| <a name="input_pe_eyaml_private_key"></a> [pe\_eyaml\_private\_key](#input\_pe\_eyaml\_private\_key) | n/a | `string` | `"no_eyaml_private_key"` | no |
| <a name="input_pe_eyaml_public_key"></a> [pe\_eyaml\_public\_key](#input\_pe\_eyaml\_public\_key) | n/a | `string` | `"no_eyaml_public_key"` | no |
| <a name="input_pe_public_ip"></a> [pe\_public\_ip](#input\_pe\_public\_ip) | n/a | `string` | `"pe_public_ip"` | no |
| <a name="input_pe_puppet_role"></a> [pe\_puppet\_role](#input\_pe\_puppet\_role) | n/a | `string` | `"pe_puppet_role"` | no |
| <a name="input_pe_version"></a> [pe\_version](#input\_pe\_version) | n/a | `string` | `"pe_version"` | no |
| <a name="input_pe_webhook_label"></a> [pe\_webhook\_label](#input\_pe\_webhook\_label) | n/a | `string` | `"pe_webhook_label"` | no |
| <a name="input_platform_fault_domain_count"></a> [platform\_fault\_domain\_count](#input\_platform\_fault\_domain\_count) | Availability set platform fault domain count | `string` | `"3"` | no |
| <a name="input_platform_update_domain_count"></a> [platform\_update\_domain\_count](#input\_platform\_update\_domain\_count) | Availability set platform update domain count | `string` | `"5"` | no |
| <a name="input_proxy_url"></a> [proxy\_url](#input\_proxy\_url) | URL of proxy server endpoint if specific proxy required, e.g. http://<proxy-server>:<proxy-port>. Defaults to 'no-proxy' - representing the case that no proxy server will be configured | `string` | `"no_proxy"` | no |
| <a name="input_public_ip_address_allocation"></a> [public\_ip\_address\_allocation](#input\_public\_ip\_address\_allocation) | Public IP to allocate to each VM. Dynamic, Static or None | `string` | `"None"` | no |
| <a name="input_puppet_agent_environment"></a> [puppet\_agent\_environment](#input\_puppet\_agent\_environment) | Name of the Puppet environment the VM should attach to | `string` | `"production"` | no |
| <a name="input_puppet_agent_url"></a> [puppet\_agent\_url](#input\_puppet\_agent\_url) | Windows only. Url for the puppet agent msi to be used | `string` | `"https://downloads.puppetlabs.com/windows/puppet5/puppet-agent-x64-latest.msi"` | no |
| <a name="input_puppet_autosign_key"></a> [puppet\_autosign\_key](#input\_puppet\_autosign\_key) | Autosign key to join the Puppet master without intervention | `string` | `"no_puppet"` | no |
| <a name="input_puppet_role"></a> [puppet\_role](#input\_puppet\_role) | Puppet role that'll be used to configure this VM | `string` | `"server"` | no |
| <a name="input_puppetmaster_fqdn"></a> [puppetmaster\_fqdn](#input\_puppetmaster\_fqdn) | The FQDN of a puppetmaster that will configure this VM | `string` | `"puppetmaster.azure.hiscox.com"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The target resource group this module should be deployed into. If not specified one will be created for you with name like: environment-application-template-location | `string` | `""` | no |
| <a name="input_server_environment"></a> [server\_environment](#input\_server\_environment) | Used to generate the name of servers based on the server-identification standard. E.g a value of 'uat' will prefix your VM names with 'ut'. Allowed values can be found in `server-identification/locals.tf` | `string` | n/a | yes |
| <a name="input_service"></a> [service](#input\_service) | The name of the service this vm fulfills, e.g app, database. Valid values are in the server-identification module | `string` | n/a | yes |
| <a name="input_shir_auth_key"></a> [shir\_auth\_key](#input\_shir\_auth\_key) | The auth key for a data factory the self-hosted integration runtime should register with | `string` | `""` | no |
| <a name="input_shir_certificate_domain"></a> [shir\_certificate\_domain](#input\_shir\_certificate\_domain) | The domain name of the certificate for SHIR | `string` | `""` | no |
| <a name="input_shir_certificate_name"></a> [shir\_certificate\_name](#input\_shir\_certificate\_name) | The name of the certificate in KeyVault to use for the SHIR | `string` | `""` | no |
| <a name="input_shir_key_vault_name"></a> [shir\_key\_vault\_name](#input\_shir\_key\_vault\_name) | The name of the KeyVault containing the certificate for the SHIR | `string` | `""` | no |
| <a name="input_shir_key_vault_resource_group_name"></a> [shir\_key\_vault\_resource\_group\_name](#input\_shir\_key\_vault\_resource\_group\_name) | The name of the resource group of the KeyVault containing the certificate for the SHIR | `string` | `""` | no |
| <a name="input_shir_secret_name"></a> [shir\_secret\_name](#input\_shir\_secret\_name) | The name of the KeyVault secret for the private key of the SHIR certificate | `string` | `""` | no |
| <a name="input_source_image_reference"></a> [source\_image\_reference](#input\_source\_image\_reference) | Image data | `map(string)` | <pre>{<br>  "offer": "RHEL",<br>  "publisher": "RedHat",<br>  "sku": "7-LVM",<br>  "version": "latest"<br>}</pre> | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | ID of the subnet to deploy VMs to | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to be applied to resources | `map(string)` | `{}` | no |
| <a name="input_use_azure_disk_encryption"></a> [use\_azure\_disk\_encryption](#input\_use\_azure\_disk\_encryption) | Enable azure disk encryption for OS disk and managed disk. NB: For Linux, source\_image\_reference must be updated to use 7.8.* version as RHEL 7.9 not supported for ADE (Nov 2020). | `bool` | `false` | no |
| <a name="input_vm_count_linux"></a> [vm\_count\_linux](#input\_vm\_count\_linux) | Number of VMs to create in the cluster | `number` | `0` | no |
| <a name="input_vm_count_windows"></a> [vm\_count\_windows](#input\_vm\_count\_windows) | Number of VMs to create in the cluster | `number` | `0` | no |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | Virtual Machine Size | `any` | n/a | yes |

## Outputs

No outputs.
