/*
    Terraform configuration file defining variables
*/
variable "environment" {
  type        = string
  description = "The environment name. Used as a tag and in naming the resource group"
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

variable "ip_rules" {
  description = "IPs or IP ranges that are allowed to connect to key vault"
  type        = list(string)
  default     = []
}

variable "subnet_ids" {
  description = "Subnet IDs that are allowed to connect to key vault"
  type        = list(string)
  default     = []
}

variable "vault_sku" {
  description = "Quality of the vault. Options are standard or premium"
  default     = "standard"
}

variable "enabled_for_deployment" {
  description = " Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault"
  default     = true
}

variable "enabled_for_disk_encryption" {
  description = "Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys"
  default     = true
}

variable "enabled_for_template_deployment" {
  description = "Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault"
  default     = true
}

variable "access_policies" {
  type        = list(map(any))
  description = <<EOL
List of map of list of string defining access policies for the Key Vault. 
See [terraform docs](https://www.terraform.io/docs/providers/azurerm/r/key_vault.html#certificate_permissions) for more info.
Each map item in the list can define a combination of *user_principal_names*, *group_names* or *object_ids* with a combination of **secret_permissions**, **key_permissions**, **certificate_permissions** or **storage_permissions**. 
All fields are not required to be defined in each map. Eg
\```
[
  {
    user_principal_names = ["user1@domain","user2@domain"]
    certificate_permissions = ["create","delete","get","import"]
  },
  {
    group_names = ["group","another_group"]
    secret_permissions = ["get","list","set"]
    key_permissions = ["get","list"]
  },
  {
    object_ids = ["xxxxxxx-xxxxx-xxxx-xxxxxx","yyyyyy-yyyyy-yyyyy-yyyyyy"]
    group_names = ["some_group"]
    storage_permissions = ["backup","restore"]
  }
]
\```
EOL
  default     = []
}

variable "secrets" {
  description = "Map of secrets to be added to the vault.  N.B.   Remember values will be stored in tfstate. Only use this to seed initial values, change them after creation"
  type        = map(string)
  default     = {}
  # note - cannot set secrets as sensitive as it's used in foreach loop
}

variable "enable_diagnostics" {
  default     = "false"
  description = "Flag to be used if diagnostics monitoring is desired in compliance with Azure CIS 1.1.0. Possible values are \"true\" and \"false\""
  type        = string
}

variable "enable_law_diagnostics" {
  default     = true
  description = "Flag use to deterministically set Log Analytics Workspace for use by diagnostics setting. Must be used in conjunction with `enable_diagnostics` field."
  type        = bool
}

variable "log_analytics_name" {
  description = "Name of log anaylitics space to use for diagnostics logging. Required if enable_diagnostics is enabled"
  default     = ""
}

variable "log_analytics_rg" {
  description = "Resource group of log anaylitics space to use for diagnostics logging. Required if enable_diagnostics is enabled"
  default     = ""
}

variable "enable_storage_account_diagnostics" {
  default     = true
  description = "Flag used to deterministically set storage account for use by diagnostics setting. Must be used in conjunction with `enable_diagnostics` field."
  type        = bool
}

variable "storage_account_name" {
  description = "Name of storage account space to use for diagnostics logging. Required if enable_diagnostics is enabled"
  default     = ""
}

variable "storage_account_rg" {
  description = "Resource group of storage account space to use for diagnostics logging. Required if enable_diagnostics is enabled"
  default     = ""
}

variable "enable_all_metrics_retention_policy" {
  default     = false
  description = "Flag to be used if it is desired to set a custom retention policy for AllMetrics metrics. Possible values are \"true\" and \"false\""
  type        = bool
}

variable "enable_audit_event_retention_policy" {
  default     = false
  description = "Flag to be used if it is desired to set a custom retention policy for AuditEvent logs. Possible values are \"true\" and \"false\""
  type        = bool
}

variable "all_metrics_retention_days" {
  default     = 30
  description = "The number of days that the AllMetrics metrics should be retained for"
  type        = number
}

variable "audit_event_retention_days" {
  default     = 30
  description = "The number of days that the AuditEvent logs should be retained for"
  type        = number
}

variable "soft_delete_enabled" {
  description = "Should Soft Delete be enabled for this Key Vault?"
  default     = false
}

variable "soft_delete_retention_days" {
  description = "The number of days that items should be retained for once soft-deleted"
  default     = 90
}

variable "purge_protection_enabled" {
  description = "Is Purge Protection enabled for this Key Vault?"
  default     = false
}

variable "issuer_name" {
  description = "Certificate issuer name"
  default     = "CA authority"
}

variable "provider_name" {
  description = "Certificate provider name"
  default     = "CA authority"
}

variable "ca_integration" {
  description = "Integrate with certificate issuer?"
  default     = false
}

variable "ca_user" {
  description = "Certificate issuer account username"
  default     = "CA user"
}

variable "ca_secret" {
  description = "Certificate issuer account password"
  default     = "CA password"
  sensitive   = true
}

variable "ca_org_id" {
  description = "Certificate issuer Org ID"
  default     = "CA Org Id"
}

variable "admin_firstname" {
  description = "Details for certificate issuer admin"
  default     = "CA"
}

variable "admin_lastname" {
  description = "Details for certificate issuer admin"
  default     = "Admin"
}

variable "admin_phone" {
  description = "Details for certificate issuer admin"
  default     = "1234567890"
}

variable "admin_email" {
  description = "Details for certificate issuer admin"
  default     = "platformservicesgroup@hiscox.com"
}

variable "enable_user_supplied_environment" {
  default     = "false"
  description = "Flag to be used to enable user supplied name insted of auto generated name. Possible values are \"true\" and \"false\""
  type        = string
}