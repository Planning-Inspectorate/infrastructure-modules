/*
    Terraform configuration file defining variables
*/
variable "environment" {
  type        = string
  description = "The environment name. Used as a tag and in naming the resource group"
}

variable "server_environment" {
  type        = string
  description = "Used to generate the name of servers based on the server-identification standard. E.g a value of 'uat' will prefix your VM names with 'ut'. Allowed values can be found in `server-identification/locals.tf`"
}

variable "application" {
  type        = string
  description = "Name of the application"
}

variable "location" {
  type        = string
  description = "The region resources will be deployed to"
  default     = "northeurope"
}

variable "tags" {
  type        = map(string)
  description = "List of tags to be applied to resources"
  default     = {}
}

variable "resource_group_name" {
  type        = string
  description = "The target resource group this module should be deployed into. If not specified one will be created for you with name like: environment-application-template-location"
  default     = ""
}

variable "business" {
  type        = string
  description = "The name of the business unit this resource belongs to. One of: it_services, us, uk, europe, london_market, group, hiscox_re"
}

variable "service" {
  type        = string
  description = "The name of the service this vm fulfills, e.g app, database. Valid values are in the server-identification module"
}

variable "puppetmaster_fqdn" {
  type        = string
  description = "The FQDN of a puppetmaster that will configure this VM"
  default     = "production-puppetmaster-northeurope.azure.hiscox.com"
}

variable "puppet_role" {
  type        = string
  description = "Puppet role that'll be used to configure this VM"
  default     = "server"
}

variable "puppet_agent_environment" {
  type        = string
  description = "Name of the Puppet environment the VM should attach to"
  default     = "production"
}

variable "puppet_autosign_key" {
  type        = string
  description = "Autosign key to join the Puppet master without intervention"
  default     = "no_puppet"
  sensitive   = true
}

variable "puppet_agent_url" {
  type        = string
  description = "Windows only. Url for the puppet agent msi to be used"
  default     = "https://downloads.puppetlabs.com/windows/puppet5/puppet-agent-x64-latest.msi"
}

variable "proxy_url" {
  type        = string
  description = "URL of proxy server endpoint if specific proxy required, e.g. http://<proxy-server>:<proxy-port>. Defaults to 'no-proxy' - representing the case that no proxy server will be configured"
  default     = "no_proxy"
}

variable "dns_suffix" {
  type    = string
  default = "azure.hiscox.com"
}

variable "load_balancer_backend_address_pools_ids" {
  type        = list(string)
  default     = []
  description = "List of resource IDs of azure load balancer backend pools to which NICs should be added"
}

# variable "application_security_group_ids" {
#   type        = list(string)
#   default     = []
#   description = "List of resource IDs for application security groups to associate the NICs to."
# }

variable "subnet_id" {
  description = "ID of the subnet to deploy VMs to"
}

variable "network_security_group_id" {
  type        = list(string)
  description = "Associate Network Security Group ID with VM"
  default     = []
}

variable "public_ip_address_allocation" {
  type        = string
  default     = "None"
  description = "Public IP to allocate to each VM. Dynamic, Static or None"
}

variable "vm_size" {
  description = "Virtual Machine Size"
}

variable "vm_count_linux" {
  type        = number
  description = "Number of VMs to create in the cluster"
  default     = 0
}

variable "vm_count_windows" {
  type        = number
  description = "Number of VMs to create in the cluster"
  default     = 0
}

variable "init_scripts" {
  type        = list(string)
  description = "Names of scripts to be rendered and executed as part of VM provisioning"
  default     = ["puppet_agent"]
}

variable "source_image_reference" {
  description = "Image data "
  type        = map(string)

  default = {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "7-LVM"
    version   = "latest"
  }
}

variable "admin_username" {
  type        = string
  description = "Admin username for the host"
  default     = "azureuser"
}

variable "admin_password" {
  type        = string
  description = "Admin password for the host"
  sensitive   = true
}

variable "patching" {
  type        = string
  default     = "0"
  description = "Allocates VM to Ivanti Patch Group"
}

variable "disk_count_linux" {
  description = "Number of additional disks to create"
  default     = 0
}

variable "disk_count_windows" {
  description = "Number of additional disks to create"
  default     = 0
}

variable "disk_sizes_linux" {
  description = "Size of additional disks in GB"
  type        = list(string)
  default     = []
}

variable "disk_os_size_linux" {
  description = "Size of linux os disk in GB"
  type        = string
  default     = "32"
}

variable "disk_skus_linux" {
  description = "SKU of the additional disks. Valid values: Standard_LRS, Premium_LRS, StandardSSD_LRS or UltraSSD_LRS"
  type        = list(string)
  default     = []
}

variable "disk_caching_linux" {
  description = "Option to enable disk caching. Valid values: None, ReadOnly and ReadWrite"
  type        = list(string)
  default     = []
}

variable "disk_sizes_windows" {
  description = "Size of additional disks in GB"
  type        = list(string)
  default     = []
}

variable "disk_os_size_windows" {
  description = "Size of windows os disk in GB"
  type        = string
  default     = "127"
}

variable "disk_skus_windows" {
  description = "SKU of the additional disks. Valid values: Standard_LRS, Premium_LRS, StandardSSD_LRS or UltraSSD_LRS"
  type        = list(string)
  default     = []
}

variable "disk_caching_windows" {
  description = "Option to enable disk caching. Valid values: None, ReadOnly and ReadWrite"
  type        = list(string)
  default     = []
}

variable "data_disk" {
  type        = list(object({ drive_letter = string, label = string, disk_luns = list(number), interleave = number, allocation_unit_size = number }))
  description = <<EOF
    Example: data_disk = [
      {
        drive_letter         = "e"
        label                = "data"
        disk_luns            = [0,1,2,3]
        interleave           = 65536
        allocation_unit_size = 65536
      },
      {
        drive_letter         = "f"
        label                = "logs"
        disk_luns            = [4]
        interleave           = null
        allocation_unit_size = 4096
      },
      {
        drive_letter         = "t"
        label                = "backup"
        disk_luns            = [5,6]
        interleave           = 65536
        allocation_unit_size = 65536
    }
  ]
EOF
  default     = []
}

variable "disk_format_suffix" {
  description = "number format option for disk suffix"
  type        = string
  default     = "%02d"
}

variable "enable_backend_pool_association" {
  default = false
}

variable "network_interface_ip_configuration_name" {
  type        = string
  default     = "Default"
  description = "Name for the IP Configuration attached to the Network Interface created for the Virtual Machine. If default value is not changed it will match the VM name."
}

variable "platform_fault_domain_count" {
  type        = string
  description = "Availability set platform fault domain count"
  default     = "3"
}

variable "platform_update_domain_count" {
  type        = string
  description = "Availability set platform update domain count"
  default     = "5"
}

variable "shir_auth_key" {
  type        = string
  description = "The auth key for a data factory the self-hosted integration runtime should register with"
  default     = ""
  sensitive   = true
}

variable "shir_certificate_domain" {
  type        = string
  description = "The domain name of the certificate for SHIR"
  default     = ""
}

variable "shir_certificate_name" {
  type        = string
  description = "The name of the certificate in KeyVault to use for the SHIR"
  default     = ""
}

variable "shir_secret_name" {
  type        = string
  description = "The name of the KeyVault secret for the private key of the SHIR certificate"
  default     = ""
}

variable "shir_key_vault_name" {
  type        = string
  description = "The name of the KeyVault containing the certificate for the SHIR"
  default     = ""
}

variable "shir_key_vault_resource_group_name" {
  type        = string
  description = "The name of the resource group of the KeyVault containing the certificate for the SHIR"
  default     = ""
}

variable "pe_version" {
  type    = string
  default = "pe_version"
}

variable "bitbucket_team" {
  type    = string
  default = "bitbucket_team"
}

variable "bitbucket_username" {
  type    = string
  default = "bitbucket_username"
}

variable "bitbucket_password" {
  type      = string
  default   = "bitbucket_password"
  sensitive = true
}

variable "control_repo_name" {
  type    = string
  default = "control_repo_name"
}

variable "pe_console_admin_password" {
  type      = string
  default   = "pe_console_admin_password"
  sensitive = true
}

variable "pe_console_url" {
  type    = string
  default = "pe_console_url"
}

variable "pe_public_ip" {
  type    = string
  default = "pe_public_ip"
}

variable "pe_webhook_label" {
  type    = string
  default = "pe_webhook_label"
}

variable "pe_deploy_key_label" {
  type    = string
  default = "pe_deploy_key_label"
}

variable "pe_puppet_role" {
  type    = string
  default = "pe_puppet_role"
}

variable "pe_agent_specified_environment" {
  type    = string
  default = "production"
}

variable "pe_eyaml_private_key" {
  type      = string
  default   = "no_eyaml_private_key"
  sensitive = true
}

variable "pe_eyaml_public_key" {
  type    = string
  default = "no_eyaml_public_key"
}

variable "pe_puppetmaster_replica" {
  type    = string
  default = "no_puppetmaster_replica"
}

variable "disk_server_identity_override" {
  type        = bool
  description = "Used to force the disks to use server-identification for name (true) instead of local.name (false). Values can be true/false"
  default     = false
}

variable "asg_name_override" {
  type        = bool
  description = "Used to force the application security group to use the name (false) or the resource_group_name (true). Values can be true/false"
  default     = false
}

variable "encryption_at_host_enabled" {
  type        = bool
  description = "Should all of the disks (including the temp disk) attached to this Virtual Machine be encrypted. Values can be true/false"
  default     = false
}

variable "use_azure_disk_encryption" {
  type        = bool
  description = "Enable azure disk encryption for OS disk and managed disk. NB: For Linux, source_image_reference must be updated to use 7.8.* version as RHEL 7.9 not supported for ADE (Nov 2020)."
  default     = false
}

variable "ade_key_vault_uri" {
  type        = string
  description = "URI of the key vault to be used for Azure Disk Encryption"
  default     = ""
}

variable "ade_key_vault_id" {
  type        = string
  description = "ID of the key vault to be used for Azure Disk Encryption"
  default     = ""
}

variable "vm_plan_linux" {
  type        = bool
  description = "Enable the VM plan block that is required for some marketplace resources"
  default     = false
}

variable "waf_ip_addresses" {
  type        = list(string)
  description = "List of Barracuda IPs used to establish a cluster"
  default     = []
}

variable "waf_license_keys" {
  type        = list(string)
  description = "Licenses to be installed on Barracuda WAFs"
  default     = []
}

variable "waf_sku" {
  type        = string
  description = "Model/version of the barracuda WAF"
  default     = "waf_sku"
}

variable "waf_password" {
  type        = string
  description = "Admin password to the Barracuda WAF portal"
  default     = "waf_password"
  sensitive   = true
}

variable "waf_cluster_secret" {
  type        = string
  description = "Secret used to join Barracuda WAFs in a cluster"
  default     = "waf_cluster_secret"
  sensitive   = true
}

variable "waf_oms_workspace_id" {
  type        = string
  description = "Workspace to stream Barracuda WAF logs to"
  default     = "waf_oms_workspace_id"
}

variable "waf_oms_workspace_key" {
  type        = string
  description = "Workspace to stream Barracuda WAF logs to"
  default     = "waf_oms_workspace_key"
}

variable "existing_storage_account_name" {
  description = "This will make the module use an existing storage account for boot diagnostics"
  type        = string
  default     = ""
}

variable "existing_storage_account_rg_name" {
  description = "This will make the module look for an existing storage account on this resource group for boot diagnostics"
  type        = string
  default     = ""
}

variable "log_workspace_integration" {
  type = object({
    enabled       = bool
    workspace_id  = string
    workspace_key = string
  })
  description = "Should the Log Analytics agent extension be enabled and which workspace should be used"
  default = {
    enabled       = false
    workspace_id  = ""
    workspace_key = ""
  }
  sensitive = true
}

variable "storage_soft_delete_retention_policy" {
  type        = bool
  description = "Is soft delete enabled for containers and blobs?"
  default     = false
}