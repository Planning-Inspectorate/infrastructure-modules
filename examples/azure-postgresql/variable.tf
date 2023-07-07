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


variable "postgresql_server_name" {
  description = "PostgreSQL server Name"
  default     = ""
}
variable "postgresql_server_version" {
  type        = string
  description = "Specifies the version of PostgreSQL to use. Valid values are 9.5, 9.6, 10, 10.0, and 11"
  default     = "11"
}

variable "postgresql_server_min_ssl_version" {
  type        = string
  description = "The minimum TLS version to support on the sever. Do not use TLS1_0 or TLS1_1"
  default     = "TLS1_2"
}

variable "postgresql_server_sku" {
  type        = string
  description = "Specifies the SKU Name for this PostgreSQL Server. The name of the SKU, follows the tier + family + cores pattern"
  default     = "GP_Gen5_2"
}

variable "postgresql_server_storage" {
  type        = number
  description = "Max storage allowed for a server. Possible values are between 5120 MB(5GB) and 1048576 MB(1TB) for the Basic SKU and between 5120 MB(5GB) and 16777216 MB(16TB) for General Purpose/Memory Optimized SKUs."
  default     = 5120
}
variable "postgresql_server_backup_retention" {
  type        = number
  description = "Backup retention days for the server, supported values are between 7 and 35 days"
  default     = 7
}

variable "postgresql_server_geo_backup" {
  type        = bool
  description = "Turn Geo-redundant server backups on/off. This allows you to choose between locally redundant or geo-redundant backup storage in the General Purpose and Memory Optimized tiers. When the backups are stored in geo-redundant backup storage, they are not only stored within the region in which your server is hosted, but are also replicated to a paired data center. This provides better protection and ability to restore your server in a different region in the event of a disaster. This is not support for the Basic tier."
  default     = false
}

variable "postgresql_server_auto_grow" {
  type        = bool
  description = "Enable/Disable auto-growing of the storage. Storage auto-grow prevents your server from running out of storage and becoming read-only. If storage auto grow is enabled, the storage automatically grows without impacting the workload. The default value if not explicitly specified is true"
  default     = true
}

variable "postgresql_server_admin_login_name" {
  type        = string
  description = "The login name for the PostgreSQL server administrator (<env><app>_psqladmin)"
  default     = ""
}

variable "postgresql_server_admin_password" {
  type        = string
  description = "The password of the login for the PostgreSQL server administrator. Choose a password that has a minimum of 8 characters and a maximum of 128 characters. The password must contain characters from three of the following categories: English uppercase letters, English lowercase letters, Numbers, Non-alphanumeric characters"
  default     = ""
  sensitive   = true
}

variable "aad_admin_user" {
  type        = string
  description = "An Azure AD admin user"
  default     = ""
}

variable "aad_admin_group" {
  description = "An Azure AD admin group"
  default     = ""
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Whether or not public network access is allowed for this server."
  default     = false
}
variable "fwrules" {
  type        = list(map(string))
  description = <<-EOT
  "List of maps detailing firewall rules with the following structure:
  [
    {
      name             = "examplefwrule"
      start_ip_address = "0.0.0.0"
      end_ip_address   = "0.0.0.0"
    }
  ]"
  EOT
  default     = []
}

variable "fwrule_include_sharedBuildAgents" {
  type        = bool
  description = "A boolean switch to allow for scenarios where the default set of shared cicd subnets (containing for example Bamboo/ADO agents) should not be added to the PostgreSQL server firewall rules."
  default     = true
}

variable "postgresql_database" {
  type        = list(map(string))
  description = <<-EOT
  "List of PostgreSQL databases, each map must contain a name field. Optional parameters that can be overriden (defaults can be found under locals.tf):
  {
    charset
    collation
  }"
  EOT
  default = [
    {
      name = "default-database"
    },
  ]
}
