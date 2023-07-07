/*
* # azure-sql
* 
* Creates an azure sql server with optional standalone or elastic pool databases
* It supports the setting of sql-server-level firewall rules and AAD administrator
* 
* The AAD admin can be a user or a group, but defaults to zSQLAdmin (Data Tribe admin group)
* Note that this will mean for previously unset Azure SQL server AAD admins, this DBA admin group will now be set (as a in-place, non-breaking change)
* This is recommended to give the Hiscox DBAs access to all SQL servers
*
* Supports the deployment of serverless databases (see 'sql-serverless-with-users' under the `examples` directory), when a valid SKU is passed. Serverless databases 
* cannot be deployed into an elastic pool. For serverless dbs there are two optional parameters for the 'standalone_dbs' variable, 'auto_pause_delay_in_minutes'  
* and 'min_capacity', with both defaulting to null for provisioned databases. Be aware that if 'auto_pause_delay_in_minutes' is set to anything other that -1 
* (disabled) then long term retention policies will not be applied.
*
* Soft delete will be auto enabled on the storage accounts in production environments. The retention period set for both the container and blobs is 90 days.
* 
* Contained database users (SQL users, AD users / Groups, MI or SP) can be created via the module with db roles assigned (See 'sql-serverless-with-users'
* under the `examples` directory). If permissions are to be managed via groups (as is recommended) then Azure AD groups need to be created for Azure objects
* such as Managed Identities or Service Principles
* 
* ## Where appropriate it is recommended that the below AD objects be created in advanced for each environment, before the respective contained users are applied in Terraform:
*
* * Active Directory on prem: create an OU named after the environment under the path `OU=${application},OU=${project/program},OU=${subscription},OU=Azure,DC=HISCOX,DC=COM` with the below security groups:
* 
*   ${environment}_${application}_db_owner
*
*   ${environment}_${application}_db_writer
*
*   ${environment}_${application}_db_reader
* 
* * Azure Active Directory: for each environment create the following security groups:
* 
*   ${environment}_${application}_db_owner_mi
*
*   ${environment}_${application}_db_writer_mi
*
*   ${environment}_${application}_db_reader_mi
* 
* * Build agent for infrastructure requires: Azure CLI, Terraform, SQLCMD v13.1+
* * The Service Principal used to execute this terraform requires permissions to `Read and write all applications`, `Read and write directory data` and `Sign in and read user profile` within the Windows Azure Active Directory API
* * Service Endpoints: the local vnet requires two service endpoints, Microsoft.Sql and Microsoft.Storage. Your bamboo agent vnet requires the Microsoft.Sql service endpoint to permit deployments
* 
* ## How To Use
*
* NB: to create a failover cluster take a look at `sql-with-failover` under the `examples` directory
*
* ### Elastic Pool
*
* ```terraform
* module "sql_primary" {
*   source                   = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-sql"
*   environment                        = var.environment
*   application                        = var.application
*   resource_group_name                = azurerm_resource_group.rg_primary.name
*   location                           = "northeurope"
*   allow_subnet_ids                   = var.allow_subnet_ids
*   elastic_pool_capacity              = var.elastic_pool_capacity
*   elastic_pool_sku                   = var.elastic_pool_sku
*   pool_dbs                           = var.pool_dbs
*   sql_server_ads_email_notifications = var.sql_server_ads_email_notifications
*   ad_sql_service_account             = var.ad_sql_service_account
*   ad_sql_service_account_password    = var.ad_sql_service_account_password
* }
* ```
* 
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
* 
* ## Items for next major version
* 
* 1. The code around firewall rules need to be tidied up / combined. Due to evolving changes, firewall restrictions have been separately introduced for the storage account and for the azure sql server. The following items to change should be considered:
*   - Combine the specification of firewall rules into a single variable, now clearly applicable to both storage account and sql server
*   - Leave in the logic (but maybe tidy as a result of other points here) around only adding FW rules to SQL server for the same region (storage accounts can have FW rules from ALL regions)
*   - Add possibility to pass in details of an existing storage account rather than this module always creating one?
*   - Remove from the storage account TF code the example around support for the use case for cloud witnesses - this is irrelevant to this azure-sql module
*/

// if you do not specify an existing resurce group one will be created for you,
// when supplying the resource group name to a resource declaration you should use
// the data type i.e 'data.azurerm_resource_group.rg.name'
resource "azurerm_resource_group" "rg" {
  count    = var.resource_group_name == "" ? 1 : 0
  name     = "${var.environment}-${var.application}-sql-${var.location}"
  location = var.location
  tags     = local.tags
}

# Generates secure string to be used as SQL Admin password in case value not provided by the user
resource "random_password" "sql_admin_password" {
  length           = 16
  special          = true
  min_upper        = 1
  min_lower        = 1
  min_numeric      = 1
  override_special = "!?_."
}

resource "azurerm_mssql_server" "sql_server" {
  name                         = "${var.environment}-${var.application}-sql-${var.location}"
  resource_group_name          = data.azurerm_resource_group.rg.name
  location                     = var.location
  version                      = var.sql_server_version
  administrator_login          = local.administrator_login_name
  administrator_login_password = local.sql_server_admin_password

  identity {
    type = "SystemAssigned"
  }

  azuread_administrator {
    login_username = coalesce(var.ad_sql_service_account, "unset") == "unset" ? var.sql_admin_group : var.ad_sql_service_account
    object_id      = coalesce(var.ad_sql_service_account, "unset") == "unset" ? data.azuread_group.sql_admin_group[0].object_id : data.azuread_user.sql_admin_user[0].object_id
  }

  tags = local.tags
}

resource "azurerm_mssql_server_extended_auditing_policy" "audit_policy" {
  server_id         = azurerm_mssql_server.sql_server.id
  storage_endpoint  = azurerm_storage_account.storage.primary_blob_endpoint
  retention_in_days = var.audit_retention_days
  depends_on = [
    azurerm_role_assignment.blob_contributor
  ]
}

resource "azurerm_mssql_elasticpool" "pool" {
  count               = length(var.elastic_pool_sku) > 0 ? 1 : 0
  name                = "${var.environment}-${var.application}-pool"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location
  tags                = local.tags
  server_name         = azurerm_mssql_server.sql_server.name
  max_size_gb         = var.elastic_pool_max_size_gb

  dynamic "sku" {
    for_each = [local.sku_with_capacity]
    content {
      capacity = sku.value.capacity
      family   = lookup(sku.value, "family", null)
      name     = sku.value.name
      tier     = sku.value.tier
    }
  }

  per_database_settings {
    min_capacity = 0
    max_capacity = local.sku_with_capacity["capacity"]
  }
}

resource "azurerm_mssql_database" "pool_database" {
  for_each = var.pool_dbs

  name                        = each.key
  tags                        = local.tags
  server_id                   = azurerm_mssql_server.sql_server.id
  elastic_pool_id             = azurerm_mssql_elasticpool.pool[0].id
  max_size_gb                 = var.is_secondary == true ? null : each.value.max_size_gb
  create_mode                 = var.is_secondary == true ? "Secondary" : "Default"
  creation_source_database_id = var.is_secondary == true ? var.source_dbs[each.key] : null

  depends_on = [
    azurerm_mssql_server.sql_server,
    azurerm_mssql_elasticpool.pool,
  ]

  long_term_retention_policy {
    weekly_retention = var.ltr_weekly_retention
    yearly_retention = var.ltr_yearly_retention
    week_of_year     = 52
  }

  short_term_retention_policy {
    retention_days = var.short_term_backup_retention
  }

}

resource "azurerm_mssql_database" "database" {
  for_each = local.standalone_dbs

  name                        = each.key
  tags                        = local.tags
  server_id                   = azurerm_mssql_server.sql_server.id
  collation                   = each.value.collation
  max_size_gb                 = each.value.max_size_gb
  sku_name                    = each.value.sku_name
  auto_pause_delay_in_minutes = each.value.auto_pause_delay_in_minutes
  min_capacity                = each.value.min_capacity
  create_mode                 = var.is_secondary == true ? "Secondary" : "Default"
  creation_source_database_id = var.is_secondary == true ? var.source_dbs[each.key] : null

  dynamic "long_term_retention_policy" {
    for_each = each.value.auto_pause_delay_in_minutes == "-1" || each.value.auto_pause_delay_in_minutes == null ? toset([1]) : toset([])
    content {
      weekly_retention = var.ltr_weekly_retention
      yearly_retention = var.ltr_yearly_retention
      week_of_year     = 52
    }
  }

  short_term_retention_policy {
    retention_days = var.short_term_backup_retention
  }
}

resource "azurerm_mssql_server_security_alert_policy" "policy" {
  resource_group_name = data.azurerm_resource_group.rg.name
  server_name         = azurerm_mssql_server.sql_server.name
  state               = "Enabled"
  # storage_endpoint           = azurerm_storage_account.storage.primary_blob_endpoint
  # storage_account_access_key = azurerm_storage_account.storage.primary_access_key
  # disabled_alerts            = var.security_disabled_alerts
  # retention_days             = var.security_retention_days
}

resource "azurerm_mssql_server_vulnerability_assessment" "va" {
  server_security_alert_policy_id = azurerm_mssql_server_security_alert_policy.policy.id
  storage_container_path          = "${azurerm_storage_account.storage.primary_blob_endpoint}vulnerability-assessment/"

  recurring_scans {
    enabled                   = true
    email_subscription_admins = false
    emails                    = local.sql_server_ads_email_notifications
  }
}

resource "mssql_user" "database_users" {
  for_each = local.database_users
    server {
      host = azurerm_mssql_server.sql_server.fully_qualified_domain_name
      login {
        username = azurerm_mssql_server.sql_server.administrator_login
        password = azurerm_mssql_server.sql_server.administrator_login_password
      }
    }
    database          = each.value.database_name
    username          = each.value.database_user
    object_id         = each.value.object_id
    password          = sensitive(each.value.database_user_password)
    roles             = split(",", each.value.database_user_role)
  depends_on = [azurerm_mssql_database.pool_database, azurerm_mssql_database.database]
}
