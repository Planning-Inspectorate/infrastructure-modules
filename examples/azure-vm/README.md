# azure-vm

This directory can stand up Linux and Windows VMs

## How To Use

### Linux VM without Public IP

```terraform
module "vm" {
  source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-vm"
  vm_count_linux      = 1
  environment         = var.environment
  application         = var.application
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  business            = var.business
  service             = var.service
  subnet_id           = module.subnet.subnet_id
  vm_size             = var.vm_size
  admin_password      = var.admin_password

  source_image_reference = {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "7-RAW-CI"
    version   = "latest"
  }
 }
```

### Windows VM without Public IP

```terraform
module "vm" {
  source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-vm"
  vm_count_windows    = 1
  environment         = var.environment
  application         = var.application
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  business            = var.business
  service             = var.service
  subnet_id           = module.subnet.subnet_id
  vm_size             = var.vm_size
  admin_password      = var.admin_password

  source_image_reference = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
 }
```

### Linux VM with Log Analytics Integration

```terraform
module "vm" {
  source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-vm"
  vm_count_linux      = 1
  environment         = var.environment
  application         = var.application
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  business            = var.business
  service             = var.service
  subnet_id           = module.subnet.subnet_id
  vm_size             = var.vm_size
  admin_password      = var.admin_password
  log_workspace_integration = {
      enabled = true
      workspace_id          = module.law.workspace_customer_id
      workspace_key         = module.law.workspace_primary_key
  }

  source_image_reference = {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "7-RAW-CI"
    version   = "latest"
  }
 }
```

### Windows VM with disks and disk partition setup

```hcl
module "vm" {
  source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-vm"
  vm_count_windows    = 1
  environment         = var.environment
  application         = var.application
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  business            = var.business
  service             = var.service
  subnet_id           = module.subnet.subnet_id
  vm_size             = var.vm_size
  admin_password      = var.admin_password

  source_image_reference = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  init_scripts           = ["data_disk"]
  disk_count_windows     = 2
  disk_sizes_windows     = [100, 100]
  disk_skus_windows      = ["Premium_LRS", "Premium_LRS"]
  disk_caching_windows   = ["ReadWrite", "ReadWrite"]
  data_disk              = [
    {
      drive_letter         = "e"
      label                = "data"
      disk_luns            = [0,1]
      interleave           = 65536
      allocation_unit_size = 65536
    }
  ]
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
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3, < 4 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >=0.7, < 1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 2, < 3 |
| <a name="provider_null"></a> [null](#provider\_null) | >= 3, < 4 |
| <a name="provider_time"></a> [time](#provider\_time) | >=0.7, < 1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_base_linux"></a> [base\_linux](#module\_base\_linux) | ./base | n/a |
| <a name="module_base_windows"></a> [base\_windows](#module\_base\_windows) | ./base | n/a |
| <a name="module_init_linux"></a> [init\_linux](#module\_init\_linux) | ./init | n/a |
| <a name="module_init_windows"></a> [init\_windows](#module\_init\_windows) | ./init | n/a |
| <a name="module_server_name_linux"></a> [server\_name\_linux](#module\_server\_name\_linux) | ./server-identification | n/a |
| <a name="module_server_name_windows"></a> [server\_name\_windows](#module\_server\_name\_windows) | ./server-identification | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_linux_virtual_machine.vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_managed_disk.managed_disk_linux](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) | resource |
| [azurerm_managed_disk.managed_disk_windows](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_virtual_machine_data_disk_attachment.data_disk_attachment_linux](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment) | resource |
| [azurerm_virtual_machine_data_disk_attachment.data_disk_attachment_windows](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment) | resource |
| [azurerm_virtual_machine_extension.linux_ade_extension](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.linux_log_agent](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.windows_log_agent](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_windows_virtual_machine.win](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine) | resource |
| [time_static.t](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [null_data_source.managed_disk_name_linux](https://registry.terraform.io/providers/hashicorp/null/latest/docs/data-sources/data_source) | data source |
| [null_data_source.managed_disk_name_windows](https://registry.terraform.io/providers/hashicorp/null/latest/docs/data-sources/data_source) | data source |

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
| <a name="input_existing_storage_account_name"></a> [existing\_storage\_account\_name](#input\_existing\_storage\_account\_name) | This will make the module use an existing storage account for boot diagnostics | `string` | `""` | no |
| <a name="input_existing_storage_account_rg_name"></a> [existing\_storage\_account\_rg\_name](#input\_existing\_storage\_account\_rg\_name) | This will make the module look for an existing storage account on this resource group for boot diagnostics | `string` | `""` | no |
| <a name="input_init_scripts"></a> [init\_scripts](#input\_init\_scripts) | Names of scripts to be rendered and executed as part of VM provisioning | `list(string)` | <pre>[<br>  "puppet_agent"<br>]</pre> | no |
| <a name="input_load_balancer_backend_address_pools_ids"></a> [load\_balancer\_backend\_address\_pools\_ids](#input\_load\_balancer\_backend\_address\_pools\_ids) | List of resource IDs of azure load balancer backend pools to which NICs should be added | `list(string)` | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | The region resources will be deployed to | `string` | `"northeurope"` | no |
| <a name="input_log_workspace_integration"></a> [log\_workspace\_integration](#input\_log\_workspace\_integration) | Should the Log Analytics agent extension be enabled and which workspace should be used | <pre>object({<br>    enabled       = bool<br>    workspace_id  = string<br>    workspace_key = string<br>  })</pre> | <pre>{<br>  "enabled": false,<br>  "workspace_id": "",<br>  "workspace_key": ""<br>}</pre> | no |
| <a name="input_network_interface_ip_configuration_name"></a> [network\_interface\_ip\_configuration\_name](#input\_network\_interface\_ip\_configuration\_name) | Name for the IP Configuration attached to the Network Interface created for the Virtual Machine. If default value is not changed it will match the VM name. | `string` | `"Default"` | no |
| <a name="input_network_security_group_id"></a> [network\_security\_group\_id](#input\_network\_security\_group\_id) | Associate Network Security Group ID with VM | `list(string)` | `[]` | no |
| <a name="input_patching"></a> [patching](#input\_patching) | Allocates VM to Ivanti Patch Group | `string` | `"0"` | no |
| <a name="input_pe_agent_specified_environment"></a> [pe\_agent\_specified\_environment](#input\_pe\_agent\_specified\_environment) | n/a | `string` | `"production"` | no |
| <a name="input_pe_console_admin_password"></a> [pe\_console\_admin\_password](#input\_pe\_console\_admin\_password) | n/a | `string` | `"pe_console_admin_password"` | no |
| <a name="input_pe_console_url"></a> [pe\_console\_url](#input\_pe\_console\_url) | n/a | `string` | `"pe_console_url"` | no |
| <a name="input_pe_deploy_key_label"></a> [pe\_deploy\_key\_label](#input\_pe\_deploy\_key\_label) | n/a | `string` | `"pe_deploy_key_label"` | no |
| <a name="input_pe_eyaml_private_key"></a> [pe\_eyaml\_private\_key](#input\_pe\_eyaml\_private\_key) | n/a | `string` | `"no_eyaml_private_key"` | no |
| <a name="input_pe_eyaml_public_key"></a> [pe\_eyaml\_public\_key](#input\_pe\_eyaml\_public\_key) | n/a | `string` | `"no_eyaml_public_key"` | no |
| <a name="input_pe_public_ip"></a> [pe\_public\_ip](#input\_pe\_public\_ip) | n/a | `string` | `"pe_public_ip"` | no |
| <a name="input_pe_puppet_role"></a> [pe\_puppet\_role](#input\_pe\_puppet\_role) | n/a | `string` | `"pe_puppet_role"` | no |
| <a name="input_pe_puppetmaster_replica"></a> [pe\_puppetmaster\_replica](#input\_pe\_puppetmaster\_replica) | n/a | `string` | `"no_puppetmaster_replica"` | no |
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
| <a name="input_puppetmaster_fqdn"></a> [puppetmaster\_fqdn](#input\_puppetmaster\_fqdn) | The FQDN of a puppetmaster that will configure this VM | `string` | `"production-puppetmaster-northeurope.azure.hiscox.com"` | no |
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
| <a name="input_storage_soft_delete_retention_policy"></a> [storage\_soft\_delete\_retention\_policy](#input\_storage\_soft\_delete\_retention\_policy) | Is soft delete enabled for containers and blobs? | `bool` | `false` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | ID of the subnet to deploy VMs to | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to be applied to resources | `map(string)` | `{}` | no |
| <a name="input_use_azure_disk_encryption"></a> [use\_azure\_disk\_encryption](#input\_use\_azure\_disk\_encryption) | Enable azure disk encryption for OS disk and managed disk. NB: For Linux, source\_image\_reference must be updated to use 7.8.* version as RHEL 7.9 not supported for ADE (Nov 2020). | `bool` | `false` | no |
| <a name="input_vm_count_linux"></a> [vm\_count\_linux](#input\_vm\_count\_linux) | Number of VMs to create in the cluster | `number` | `0` | no |
| <a name="input_vm_count_windows"></a> [vm\_count\_windows](#input\_vm\_count\_windows) | Number of VMs to create in the cluster | `number` | `0` | no |
| <a name="input_vm_plan_linux"></a> [vm\_plan\_linux](#input\_vm\_plan\_linux) | Enable the VM plan block that is required for some marketplace resources | `bool` | `false` | no |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | Virtual Machine Size | `any` | n/a | yes |
| <a name="input_waf_cluster_secret"></a> [waf\_cluster\_secret](#input\_waf\_cluster\_secret) | Secret used to join Barracuda WAFs in a cluster | `string` | `"waf_cluster_secret"` | no |
| <a name="input_waf_ip_addresses"></a> [waf\_ip\_addresses](#input\_waf\_ip\_addresses) | List of Barracuda IPs used to establish a cluster | `list(string)` | `[]` | no |
| <a name="input_waf_license_keys"></a> [waf\_license\_keys](#input\_waf\_license\_keys) | Licenses to be installed on Barracuda WAFs | `list(string)` | `[]` | no |
| <a name="input_waf_oms_workspace_id"></a> [waf\_oms\_workspace\_id](#input\_waf\_oms\_workspace\_id) | Workspace to stream Barracuda WAF logs to | `string` | `"waf_oms_workspace_id"` | no |
| <a name="input_waf_oms_workspace_key"></a> [waf\_oms\_workspace\_key](#input\_waf\_oms\_workspace\_key) | Workspace to stream Barracuda WAF logs to | `string` | `"waf_oms_workspace_key"` | no |
| <a name="input_waf_password"></a> [waf\_password](#input\_waf\_password) | Admin password to the Barracuda WAF portal | `string` | `"waf_password"` | no |
| <a name="input_waf_sku"></a> [waf\_sku](#input\_waf\_sku) | Model/version of the barracuda WAF | `string` | `"waf_sku"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_application_security_group_id_linux"></a> [application\_security\_group\_id\_linux](#output\_application\_security\_group\_id\_linux) | Resource ID of the ASG Associated to the NICs. Single element list. |
| <a name="output_application_security_group_id_windows"></a> [application\_security\_group\_id\_windows](#output\_application\_security\_group\_id\_windows) | Resource ID of the ASG Associated to the NICs. Single element list. |
| <a name="output_linux_machine_metadata"></a> [linux\_machine\_metadata](#output\_linux\_machine\_metadata) | List containing metadata about Linux VMs. Useful to loop over when multiple pieces of data are needed in the loop. |
| <a name="output_name"></a> [name](#output\_name) | The value of the `name` variable. |
| <a name="output_network_interface_ids_linux"></a> [network\_interface\_ids\_linux](#output\_network\_interface\_ids\_linux) | List of NIC resource IDs. |
| <a name="output_network_interface_ids_windows"></a> [network\_interface\_ids\_windows](#output\_network\_interface\_ids\_windows) | List of NIC resource IDs. |
| <a name="output_network_interface_ips_linux"></a> [network\_interface\_ips\_linux](#output\_network\_interface\_ips\_linux) | List of NIC IP addresses. |
| <a name="output_network_interface_ips_windows"></a> [network\_interface\_ips\_windows](#output\_network\_interface\_ips\_windows) | List of NIC IP addresses. |
| <a name="output_network_security_group_id_linux"></a> [network\_security\_group\_id\_linux](#output\_network\_security\_group\_id\_linux) | Resource ID of the NSG associated to the NICs. Single element list. |
| <a name="output_network_security_group_id_windows"></a> [network\_security\_group\_id\_windows](#output\_network\_security\_group\_id\_windows) | Resource ID of the NSG associated to the NICs. Single element list. |
| <a name="output_network_security_group_name_linux"></a> [network\_security\_group\_name\_linux](#output\_network\_security\_group\_name\_linux) | Name of the NSG associated to the NICs. Single element list. |
| <a name="output_network_security_group_name_windows"></a> [network\_security\_group\_name\_windows](#output\_network\_security\_group\_name\_windows) | Name of the NSG associated to the NICs. Single element list. |
| <a name="output_principal_ids_linux"></a> [principal\_ids\_linux](#output\_principal\_ids\_linux) | List of VM MSI service principal IDs. |
| <a name="output_principal_ids_windows"></a> [principal\_ids\_windows](#output\_principal\_ids\_windows) | List of VM MSI service principal IDs. |
| <a name="output_public_ip_ids_linux"></a> [public\_ip\_ids\_linux](#output\_public\_ip\_ids\_linux) | List of Public IP Address resource IDs associated to the NICs. |
| <a name="output_public_ip_ids_windows"></a> [public\_ip\_ids\_windows](#output\_public\_ip\_ids\_windows) | List of Public IP Address resource IDs associated to the NICs. |
| <a name="output_public_ip_names_linux"></a> [public\_ip\_names\_linux](#output\_public\_ip\_names\_linux) | List of Public IP Address names associated to the NICs. |
| <a name="output_public_ip_names_windows"></a> [public\_ip\_names\_windows](#output\_public\_ip\_names\_windows) | List of Public IP Address names associated to the NICs. |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Name of the resource group where resources have been deployed to |
| <a name="output_storage_id_linux"></a> [storage\_id\_linux](#output\_storage\_id\_linux) | The ID of the Storage Account. Single element list. |
| <a name="output_storage_id_windows"></a> [storage\_id\_windows](#output\_storage\_id\_windows) | The ID of the Storage Account. Single element list. |
| <a name="output_storage_name_linux"></a> [storage\_name\_linux](#output\_storage\_name\_linux) | The name of the storage account. Single element list. |
| <a name="output_storage_name_windows"></a> [storage\_name\_windows](#output\_storage\_name\_windows) | The name of the storage account. Single element list. |
| <a name="output_storage_uri_linux"></a> [storage\_uri\_linux](#output\_storage\_uri\_linux) | The endpoint URL for blob storage in the primary location. Single element list. |
| <a name="output_storage_uri_windows"></a> [storage\_uri\_windows](#output\_storage\_uri\_windows) | The endpoint URL for blob storage in the primary location. Single element list. |
| <a name="output_tenant_ids_linux"></a> [tenant\_ids\_linux](#output\_tenant\_ids\_linux) | List of VM MSI service tenbant IDs. |
| <a name="output_tenant_ids_windows"></a> [tenant\_ids\_windows](#output\_tenant\_ids\_windows) | List of VM MSI service tenant IDs. |
| <a name="output_virtual_machine_base_name_linux"></a> [virtual\_machine\_base\_name\_linux](#output\_virtual\_machine\_base\_name\_linux) | Generated base VM name. Single element list. |
| <a name="output_virtual_machine_base_name_windows"></a> [virtual\_machine\_base\_name\_windows](#output\_virtual\_machine\_base\_name\_windows) | Generated base VM name. Single element list. |
| <a name="output_virtual_machine_ids_linux"></a> [virtual\_machine\_ids\_linux](#output\_virtual\_machine\_ids\_linux) | List of VM IDs. |
| <a name="output_virtual_machine_ids_windows"></a> [virtual\_machine\_ids\_windows](#output\_virtual\_machine\_ids\_windows) | List of VM IDs. |
| <a name="output_virtual_machine_names_linux"></a> [virtual\_machine\_names\_linux](#output\_virtual\_machine\_names\_linux) | List of VM names. |
| <a name="output_virtual_machine_names_windows"></a> [virtual\_machine\_names\_windows](#output\_virtual\_machine\_names\_windows) | List of VM names. |
| <a name="output_windows_machine_metadata"></a> [windows\_machine\_metadata](#output\_windows\_machine\_metadata) | List containing metadata about Windows VMs. Useful to loop over when multiple pieces of data are needed in the loop. |
