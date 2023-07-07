/*
* # azure-postgresql
* 
* Creates an Azure Database for PostgreSQL - Single Server
*
* ## PostgreSQL server module defaults:
*
* * Performance configuration : General Purpose, 2 vCore(s), 5 GB.
* * PostgreSQL version        : 11
* * SSL enforce status        : ENABLED
* * Minimum TLS               : 1.2
* * Backup retention          : 7 days
* * Storage Auto-growth       : Yes
* 
* ## Default Local Administrator and the Password
*
* This module creates a local administrator on the PostgreSQL server. If you want to specify an admin username, then use the argument admin_username with a valid user string.
* By default, this module generates a strong password for PostgreSQL admin user. 
*
* ## Adding Active Directory Administrator to PostgreSQL Database
* 
* This module will add a provided Azure Active Directory user/ group to PostgreSQL Database as an administrator so that the user/ group can login to this database with Azure AD authentication.
* To add the Active Directory Administrator, use the argument `aad_admin_user` or `aad_admin_group` with a valid Azure AD user/ group login name. Only one can be used so if both are supplied, the `aad_admin_group` is used.
*
* ## PostgreSQL database(s):
*
* This module creates a default-database on the PostgreSQL server. 
* If you want to use a custom database name, specify the list of `postgresql_database`.
* 
* Database defaults:
* 
* * charset                   : UTF8
* * collation                 : English_United States.1252
*
* ## Public Network Access
*
* By default, the module builds the PostgreSQL server with `public_network_access_enabled` set to `false`. As a result, a Private Endpoint will be required in order to connect.
*
* ## Firewall rules for a PostgreSQL Server
* 
* By default, external access to the PostgreSQL Server will not be possible unless `public_network_access_enabled` is set to `true`. If set, firewall rule(s) should be created. 
* To add firewall rules, specify a list of `fwrules` with valid `name`, `start_ip_address` and `end_ip_address`.
* By default, the module with configure some firewall rules to enable access from Azure services and the shared build agents. The `fwrule_include_sharedBuildAgents` bool is available to allow for scenarios where the default set of shared cicd subnets is not wanted. 
*
* ## PostgreSQL Configuration
*
* Add a `name` and 'value' to the locals 'postgresql_configuration' map to set a PostgreSQL configuration value on a PostgreSQL Server. See the PostgreSQL documentation for valid values.
*
* ## How To Use
* 
* ### Example 1
* 
* ```terraform
* module "postgresql" {
*   source              = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-postgresql"
*   environment         = var.environment
*   application         = var.application
*   location            = "northeurope"
* ```
*
* ### Example 2
* 
* ```terraform
* module "postgresql" {
*   source                        = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-postgresql"
*   environment                   = var.environment
*   application                   = var.application
*   location                      = "northeurope"
*   postgresql_database           = "postgresql_database"
*   aad_admin_user                = "firstname.surname@domain.com"
*   public_network_access_enabled = true
*   fwrules                       = var.fwrules
* ```
* 
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

// if you do not specify an existing resurce group one will be created for you,
// when supplying the resource group name to a resource declaration you should use
// the data type i.e 'data.azurerm_resource_group.rg.name'
resource "azurerm_resource_group" "rg" {
  count    = var.resource_group_name == "" ? 1 : 0
  name     = "${var.environment}-${var.application}-postgresql-${var.location}"
  location = var.location
  tags     = local.tags
}

resource "random_password" "postgresql_server_admin_password" {
  length           = 16
  special          = true
  min_upper        = 1
  min_lower        = 1
  min_numeric      = 1
  override_special = "!?_."
}

resource "random_integer" "ri" {
  min = 10000
  max = 99999
}
resource "azurerm_postgresql_server" "postgresql_server" {
  name                = var.postgresql_server_name == "" ? "${var.environment}-${var.application}postgresql-${random_integer.ri.result}" : var.postgresql_server_name
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name

  sku_name   = var.postgresql_server_sku
  version    = var.postgresql_server_version
  storage_mb = var.postgresql_server_storage

  backup_retention_days        = var.postgresql_server_backup_retention
  geo_redundant_backup_enabled = var.postgresql_server_geo_backup
  auto_grow_enabled            = var.postgresql_server_auto_grow

  administrator_login          = var.postgresql_server_admin_login_name == "" ? "${var.environment}${var.application}_psqladmin" : var.postgresql_server_admin_login_name
  administrator_login_password = var.postgresql_server_admin_password == "" ? sensitive(random_password.postgresql_server_admin_password.result) : sensitive(var.postgresql_server_admin_password)

  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = var.postgresql_server_min_ssl_version
  public_network_access_enabled    = var.public_network_access_enabled

  tags = local.tags

  lifecycle {
    ignore_changes = [
      # Ignore changes to Defender for Cloud configuration (threat_detection_policy sub-block) because it is configured and managed outside of this module.
      threat_detection_policy[0].disabled_alerts,
      threat_detection_policy[0].email_account_admins,
      threat_detection_policy[0].email_addresses,
      threat_detection_policy[0].enabled,
      threat_detection_policy[0].retention_days,
    ]
  }
}

resource "azurerm_postgresql_database" "postgresql_database" {
  for_each            = local.postgresql_database
  name                = each.key
  resource_group_name = data.azurerm_resource_group.rg.name
  server_name         = azurerm_postgresql_server.postgresql_server.name
  charset             = each.value.charset
  collation           = each.value.collation
}

resource "azurerm_postgresql_active_directory_administrator" "postgresql_aad" {
  count               = local.aad_admin == "" ? 0 : 1
  server_name         = azurerm_postgresql_server.postgresql_server.name
  resource_group_name = data.azurerm_resource_group.rg.name
  login               = local.aad_admin
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = var.aad_admin_group != "" ? data.azuread_group.aad_admin_group[0].object_id : data.azuread_user.aad_admin_user[0].object_id
}
resource "azurerm_postgresql_firewall_rule" "fwrule" {
  count               = var.public_network_access_enabled ? length(local.fwrules) : 0
  name                = local.fwrules[count.index].name
  resource_group_name = data.azurerm_resource_group.rg.name
  server_name         = azurerm_postgresql_server.postgresql_server.name
  start_ip_address    = local.fwrules[count.index].start_ip_address
  end_ip_address      = local.fwrules[count.index].end_ip_address
}

resource "azurerm_postgresql_configuration" "postgresql_configuration" {
  for_each            = local.postgresql_configuration
  name                = each.key
  resource_group_name = data.azurerm_resource_group.rg.name
  server_name         = azurerm_postgresql_server.postgresql_server.name
  value               = each.value
}