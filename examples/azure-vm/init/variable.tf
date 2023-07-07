variable "proxy_url" {
  type    = string
  default = "no_proxy"
}

variable "puppet_agent_url" {
  type    = string
  default = "https://downloads.puppetlabs.com/windows/puppet5/puppet-agent-x64-latest.msi"
}

variable "dns_suffix" {
  type    = string
  default = "azure.hiscox.com"
}

variable "puppet_role" {
  type    = string
  default = "no_puppet"
}

variable "puppet_master" {
  type    = string
  default = "no_puppet"
}

variable "pe_puppetmaster_replica" {
  type    = string
  default = "no_puppetmaster_replica"
}

variable "puppet_agent_environment" {
  type    = string
  default = "production"
}

variable "puppet_autosign_key" {
  type    = string
  default = "no_puppet"
}

variable "pe_eyaml_private_key" {
  type    = string
  default = "no_eyaml_private_key"
}

variable "pe_eyaml_public_key" {
  type    = string
  default = "no_eyaml_public_key"
}

variable "os_family" {
  type        = string
  description = "windows/linux"
}

variable "init_scripts" {
  type    = list(string)
  default = []
}

variable "custom" {
  type    = string
  default = ""
}

variable "waf_ip_addresses" {
  type    = list(string)
  default = []
}

variable "waf_license_keys" {
  type    = list(string)
  default = []
}

variable "waf_sku" {
  type    = string
  default = "waf_sku"
}

variable "waf_password" {
  type      = string
  default   = "waf_password"
  sensitive = true
}

variable "waf_cluster_secret" {
  type      = string
  default   = "waf_cluster_secret"
  sensitive = true
}

variable "waf_oms_workspace_id" {
  type    = string
  default = "waf_oms_workspace_id"
}

variable "waf_oms_workspace_key" {
  type      = string
  default   = "waf_oms_workspace_key"
  sensitive = true
}

variable "data_disk" {
  type    = list(object({drive_letter = string, label = string, disk_luns = list(number), interleave = number, allocation_unit_size = number}))
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
  default = []
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
