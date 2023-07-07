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

variable "environment_code" {
  type        = string
  description = "Shorthand environment name based on server-identification"
  default     = "ci"
}

variable "sql_server_version" {
  description = "Version of SQL Server"
  default     = "12.0"
}

variable "allow_subnet_ids" {
  type        = map(string)
  description = "A map of subnet IDs allow access to the DBs. e.g: { bamboo='...', platform='...' }"
  default     = {}
}

variable "standalone_dbs" {
  type        = map(map(string))
  description = <<-EOT
  "Map of maps containing config for standalone databases (min_capacity and auto_pause_delay_in_minutes are only relevant for serverless databases and will default to null when not populated) e.g: 
    {
      standalonedb = {
        max_size_gb                 = 6
        sku_name                    = "GP_S_Gen5_1"
        collation                   = "Latin1_General_CS_AI"
        min_capacity                = 1
        auto_pause_delay_in_minutes = 60
      }
    }"
  EOT
  default     = {}
}

variable "pool_dbs" {
  type        = map(map(string))
  description = "Map of maps containing config for elastic pool databases e.g: { pooldb1={ max_size = 32, edition='Premium', performance_level='P1'}, pooldb2={...} ]"
  default     = {}
}

variable "is_secondary" {
  type        = bool
  description = "Boolean defining whether this SQL server will be a secondary - any databases created will have their `creat_mode` set to `Secondary`"
  default     = false
}

variable "source_dbs" {
  type        = map(string)
  description = "Map of strings defining source database IDs for when server is being created as a secondary replica eg { \"name\" = \"id\" }"
  default     = {}
}

variable "elastic_pool_sku" {
  type        = map(string)
  description = <<-EOT
  "SKU for the pool {name, tier, family, capacity}, e.g {
    name     = "BC_Gen5"
    tier     = "BusinessCritical"
    family   = "Gen5"
    capacity = 4
  }"
  EOT
  default     = {}
}

variable "elastic_pool_capacity" {
  description = "The scale up/out capacity of the elastic pool, representing server's compute units (vCore-based or DTU-based) N.B. Overrides the capacity set in elastic pool sku"
  default     = 4
}

variable "elastic_pool_max_size_gb" {
  description = "The max data size of the elastic pool in gigabytes"
  default     = 256
}

variable "sql_admin_group" {
  description = "The name of the SQL server administrator group"
  default     = "zSQLAdmin"
}

variable "sql_server_admin_password" {
  description = "The password of the login for the SQL server administrator (<env><app>_sqladmin)"
  default     = ""
  sensitive   = true
}

variable "ad_sql_service_account" {
  description = "The username or the group name AAD SQL server admin. If its a user, this is traditionally the service AD Account pre-created by AD team, as an example svc_(environment_code)_(application)@hiscox.com"
  default     = ""
}

variable "ad_sql_service_account_password" {
  description = "The password of the Service AD Account pre-created by AD team as an example svc_(environment_code)_(application)@hiscox.com"
  default     = ""
  sensitive   = true
}

variable "db_bck_retention_days" {
  description = "Number of days to keep as a backup for the database. It will configure the short Azure backup retention policy. Azure default is 7 and can go up to 35"
  default     = 35
}

variable "is_db_bck_longterm_retention_required" {
  description = "Flag used to identify if long term retention policy is required for sql server databasess. 1 for true and 0 for false"
  default     = 1
}

variable "sql_server_ads_email_notifications" {
  type        = list(string)
  description = "Required emails for SQL Server advance security notifications"
  default     = []
}

variable "ltr_weekly_retention" {
  type        = string
  description = "Retention of the weekly backup, typically use P1M for production workloads"
  default     = "P7D"
}

variable "ltr_yearly_retention" {
  type        = string
  description = "Retention of the yearly backup, typically use P10Y for production workloads"
  default     = "P7D"
}

variable "security_retention_days" {
  type        = number
  description = "Retention of security audit and threat protection info"
  default     = 0
}

variable "audit_retention_days" {
  type        = number
  description = "The number of days to retain logs for in the storage account"
  default     = 90
}

variable "security_disabled_alerts" {
  type        = list(string)
  description = "List of disabled security alert types - see https://www.terraform.io/docs/providers/azurerm/r/mssql_server_security_alert_policy.html#disabled_alerts for info."
  default     = []
}

variable "network_default_action" {
  type        = string
  description = "If a source IPs fails to match a rule should it be allowed for denied"
  default     = "Deny"
}

variable "network_rule_ips" {
  type        = list(string)
  description = "List of public IPs that are allowed to access the storage account. Private IPs in RFC1918 are not allowed here"
  default     = []
}

variable "network_rule_virtual_network_subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs which are allowed to access the storage account"
  default     = []
}

variable "network_rule_virtual_network_subnet_ids_include_cicd_agents" {
  type        = bool
  description = "A boolean switch to allow for scenarios where the default set of cicd subnets (containing for example Bamboo/ADO agents) should not be added to the storage accounts network rules. An example would be a storage accounts used as a cloud witness for a windows failover cluster that exists outside of the paired regions of the cluster nodes"
  default     = true
}

variable "container_name" {
  type        = list(string)
  description = "List of names for created containers"
  default     = ["vulnerability-assessment"]
}

variable "container_access_type" {
  type        = string
  description = "The Access Level configured for this Container. Possible values are blob, container or private"
  default     = "private"
}

variable "short_term_backup_retention" {
  type        = number
  description = "Number of days to keep short term backups. Can be between 7 and 35."
  default     = 35
}

variable "database_users" {
  type = list(map(any))
  description = <<-EOT
  "List of map of strings detailng contained users to be created in Azure SQL DBs. The map structure is dependant on the user type (examples below).
  NB: The 'database_user_role' parameter requires be a comma seperated list of db roles
  [
    # SQL user example #
    {
      database_name          = "dbname"
      database_user          = "username"
      database_user_password = "xxxxxxxx"
      database_user_role     = "db_datareader, db_datawriter"
    },
    # AD user example #
    {
      database_name          = "dbname"
      database_user          = "user@hiscox.com"
      object_id              = "xxxxx-xxxx-xxxx-xxxx-xxxxx"
      database_user_role     = "db_accessadmin, db_datareader"
    },
    # AD group / MI / SP example #
    {
      database_name          = "dbname"
      database_user          = "adobjectname"
      object_id              = "xxxxx-xxxx-xxxx-xxxx-xxxxx"
      database_user_role     = "db_owner"
    },
  ]"
  EOT
  default = []
}

variable "storage_soft_delete_retention_policy" {
  type        = bool
  description = "Is soft delete enabled for containers and blobs?"
  default     = false
}