/*
* # azure-postgresql-flex
* 
* Creates an Azure Database for PostgreSQL - Flexible Server
*
* ## PostgreSQL server module defaults:
*
* * Performance configuration : General Purpose, 2 vCore(s), 8 GB.
* * PostgreSQL version        : 12
* * Backup retention          : 7 days
* * Location                  : northeurope
* 
* ## Default Local Administrator and the Password
*
* This module creates a local administrator on the PostgreSQL server. If you want to specify an admin username, then use the argument `postgresqlflx_server_admin_login_name` with a valid user string.
* You will also need to pass in a password for an admin user. As this does not yet support Active Directory you will need to ensure you have a record of these details to login to the system and configure.
* Recommendation is that you pass this in from Key Vault to ensure that sensitive data is not held in an insecure manner.
*
* ## PostgreSQL database(s):
*
* This module creates a default-database on the PostgreSQL Flexible server. 
* If you want to use a custom database name, specify the list of `postgresqlflx_database`.
* 
* Database defaults:
* 
* * charset                   : UTF8
* * collation                 : `en_US.utf8`
*
* ## Public Network Access
*
* Public Network Access cannot be set but is inferred by the settings you pass through. To not have public network access enabled you will need to define a delegated subnet for this service.
* A delegated subnet should be used in conjunction with private dns zone.
*
* ## Firewall rules for a PostgreSQL Server
* 
* To add firewall rules, specify a list of `fwrules` with valid `name`, `start_ip_address` and `end_ip_address`. Firewall rules are enabled by default.
* By default, the module will configure some firewall rules to enable access from Azure services and the shared build agents. The `fwrule_include_sharedBuildAgents` bool is available to allow for scenarios where the default set of shared cicd subnets is not wanted. 
* If delegated subnet option is passed in firewall rules will not be required.
*
* ## PostgreSQL Configuration
*
* Add a `name` and 'value' to the locals 'postgresql_configuration' map to set a PostgreSQL configuration value on a PostgreSQL flexible Server. See the PostgreSQL documentation for valid values.
*
* ## High Availability
*
* High Availablility can be set with PostgreSQL Flexible. To enable this pass through the variable ha_enabled as true and set variable `ha_availability_zone` to desired zone. Refer to documentation for zone details for the location.
*
* ## Maintenance Windows
*
* To define a custom maintenance window set the variable `maintenance_enabled` to true and define maintenance values for `maintenance_day_of_week`, `maintenance_start_hour` and `maintenance_start_minute`. Review documentation for values.
*
* ## How To Use
* 
* ### Example 1
* 
* ```terraform
* module "postgresqlflx" {
*   source              = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-postgresql-flex"
*   environment         = var.environment
*   application         = var.application
*   location            = "northeurope"
*   enable_firewall     = true
* ```
*
* ### Example 2
* 
* ```terraform
* module "postgresqlflx" {
*   source                        = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-postgresql-flex"
*   environment                   = var.environment
*   application                   = var.application
*   location                      = "northeurope"
*   postgresql_database           = "postgresql_database"
*   delegated_subnet_id           = var.delegated_subnet_id
*   private_dns_zone_id           = var.private_dns_zone_id
*   public_network_access_enabled = false
*   enable_firewall               = false
* ```
* 
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

// if you do not specify an existing resource group one will be created for you,
// when supplying the resource group name to a resource declaration you should use
// the data type i.e 'data.azurerm_resource_group.rg.name'
resource "azurerm_resource_group" "rg" {
  count    = var.resource_group_name == "" ? 1 : 0
  name     = "${var.environment}-${var.application}-postgresqlflx-${var.location}"
  location = var.location
  tags     = local.tags
}

resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

resource "azurerm_postgresql_flexible_server" "postgresqlflx_server" {
  name                = var.postgresqlflx_server_name == "" ? "${var.environment}-${var.application}postgresqlflx-${random_integer.ri.result}" : var.postgresqlflx_server_name
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name

  sku_name   = var.postgresqlflx_server_sku
  version    = var.postgresqlflx_server_version
  storage_mb = var.postgresqlflx_server_storage


  backup_retention_days        = var.postgresqlflx_server_backup_retention
  geo_redundant_backup_enabled = var.postgresqlflx_server_geo_backup

  dynamic high_availability {
    for_each = var.ha_enabled == true ? [1] : []

    content {
      mode                      = "ZoneRedundant"
      standby_availability_zone = var.ha_availability_zone
    }
  }

  dynamic maintenance_window {
    for_each = var.maintenance_enabled == true ? [1] : []

    content {
      day_of_week  = var.maintenance_day_of_week
      start_hour   = var.maintenance_start_hour
      start_minute = var.maintenance_start_minute
    }
  }

  create_mode                       = var.postgresqlflx_create_mode
  point_in_time_restore_time_in_utc = var.postgresqlflx_restore_time
  source_server_id                  = var.postgresqlflx_restore_source_id

  administrator_login    = var.postgresqlflx_server_admin_login_name == "" ? "${var.environment}${var.application}_psqladmin" : var.postgresqlflx_server_admin_login_name
  administrator_password = sensitive(var.postgresqlflx_server_admin_password)

  delegated_subnet_id = var.delegated_subnet_id
  private_dns_zone_id = var.private_dns_zone_id

  tags = local.tags

  lifecycle {
    ignore_changes = [
      zone,
      high_availability.0.standby_availability_zone,
    ]
  }

}

resource "azurerm_postgresql_flexible_server_database" "postgresqlflx_database" {
  for_each  = local.postgresqlflx_database
  name      = each.key
  server_id = azurerm_postgresql_flexible_server.postgresqlflx_server.id
  charset   = each.value.charset
  collation = each.value.collation
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "fwrule" {
  count            = var.enable_firewall == true ? length(local.fwrules) : 0
  name             = local.fwrules[count.index].name
  server_id        = azurerm_postgresql_flexible_server.postgresqlflx_server.id
  start_ip_address = local.fwrules[count.index].start_ip_address
  end_ip_address   = local.fwrules[count.index].end_ip_address
}

resource "azurerm_postgresql_flexible_server_configuration" "postgresqlflx_configuration" {
  for_each  = local.postgresqlflx_configuration
  name      = each.key
  server_id = azurerm_postgresql_flexible_server.postgresqlflx_server.id
  value     = each.value
  depends_on = [
    azurerm_postgresql_flexible_server.postgresqlflx_server
  ]
}