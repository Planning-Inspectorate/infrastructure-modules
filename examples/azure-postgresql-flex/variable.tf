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

variable "postgresqlflx_server_name" {
  description = "PostgreSQL server Name"
  default     = ""
}

variable "postgresqlflx_server_version" {
  type        = string
  description = "Specifies the version of PostgreSQL to use. Valid values are 9.5, 9.6, 10, 10.0, and 11"
  default     = "12"
}

variable "postgresqlflx_server_sku" {
  type        = string
  description = "Specifies the SKU Name for this PostgreSQL Server. The name of the SKU, follows the tier + family + cores pattern"
  default     = "GP_Standard_D2s_v3"
}

variable "postgresqlflx_configuration" {
  type        = map(string)
  description = "List of configuration options to apply to database"
  default     = {}
}

variable "postgresqlflx_server_storage" {
  type        = number
  description = "Max storage allowed for a server. Possible values are between 5120 MB(5GB) and 1048576 MB(1TB) for the Basic SKU and between 5120 MB(5GB) and 16777216 MB(16TB) for General Purpose/Memory Optimized SKUs."
  default     = 32768
}

variable "postgresqlflx_server_backup_retention" {
  type        = number
  description = "Backup retention days for the server, supported values are between 7 and 35 days"
  default     = 7
}

variable "postgresqlflx_server_geo_backup" {
  type        = bool
  description = "Turn Geo-redundant server backups on/off. This allows you to choose between locally redundant or geo-redundant backup storage in the General Purpose and Memory Optimized tiers. When the backups are stored in geo-redundant backup storage, they are not only stored within the region in which your server is hosted, but are also replicated to a paired data center. This provides better protection and ability to restore your server in a different region in the event of a disaster. This is not support for the Basic tier."
  default     = false
}

variable "postgresqlflx_server_admin_login_name" {
  type        = string
  description = "The login name for the PostgreSQL server administrator (<env><app>_psqladmin)"
  default     = ""
}

variable "postgresqlflx_server_admin_password" {
  type        = string
  description = "The password of the login for the PostgreSQL server administrator. Choose a password that has a minimum of 8 characters and a maximum of 128 characters. The password must contain characters from three of the following categories: English uppercase letters, English lowercase letters, Numbers, Non-alphanumeric characters"
  default     = ""
  sensitive   = true
}

variable "postgresqlflx_create_mode" {
  type        = string
  description = "The creation mode can be used to restore or replicate existing servers. Possible values are Default or PointInTimeRestore. Changing this forces new server to be created"
  default     = "Default"
}

variable "postgresqlflx_restore_time" {
  type        = string
  description = "UTC Point in Time to Restore Server, only used when postgresflx_create_mode is set to PointInTimeRestore. Send in RFC3339 Format as String."
  default     = null
}

variable "postgresqlflx_restore_source_id" {
  type        = string
  description = "Resource ID of source server for restore. Only used when Create Mode is set to PointInTimeRestore"
  default     = null
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

variable "postgresqlflx_database" {
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

variable "ha_enabled" {
  type        = bool
  description = "Decide whether to enable HA"
  default     = false
}

variable "ha_availability_zone" {
  type        = string
  description = "Specifies HA zone for Standby"
  default     = null
}

variable "maintenance_enabled" {
  type        = bool
  description = "Decide whether to enable Maintenance"
  default     = false
}

variable "maintenance_day_of_week" {
  type        = number
  description = "Day of week for maintenance 0 = Sunday, 7 = Saturday"
  default     = null
}

variable "maintenance_start_hour" {
  type        = number
  description = "Start hour for maintenance"
  default     = null
}

variable "maintenance_start_minute" {
  type        = number
  description = "Start minute for maintenance"
  default     = null
}

variable "delegated_subnet_id" {
  type        = string
  description = "DO NOT USE WITH EXISTING SUBNET IN USE - This must the ID of a subnet specifically created for this service and must not have any other resources on it. Use in conjunction with private_dns_zone_id"
  default     = null
}

variable "private_dns_zone_id" {
  type        = string
  description = "ID of private DNS zone to create the Postgres Flexible Server. Changing this forces new server to be created"
  default     = null
}

variable "enable_firewall" {
  type        = bool
  description = "Choose to enable firewall Rules, change to false if using delegated subnet"
  default     = true
}