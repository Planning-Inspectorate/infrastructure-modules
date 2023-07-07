/**
* # azure -keyvault
* 
* Creates a keyvault and assigns appropriate roles to manage secrets and certs 
*
* Purge protection & soft delete retention - Purge protection has now been enabled by default on production keyvaults (even if 'purge_protection_enabled' is set to false) and the default soft delete retention has
* been set to 90 days (previously 7). Purge protection can still be enabled on non-production vaults if explicitly set. N.B. If you expect to have to build and destroy a keyvault with purge protection enabled, you will
* not be able to build another vault with the same name for 90 days. Consider appending the keyvault name with random characters if there is a need to destroy and rebuild.
* A lifecycle block has been added for 'soft_delete_retention_days' and 'purge_protection_enabled' parameters to prevent breaking changes to existing keyvaults. Please update these settings manually to ensure older vaults
* conform with standards.
*
* ## How To Use
*
* Note: when using audit logging with a Log Analytics Workspace or Storage account you will need to add a `depends_on` block inside your `module "keyvault"` declaration otherwise the data types for finding the IDs will execute too early. For example if you're building a storage account alonogside the KV for audit logging you can add something like this to your KV module block:
*
* ```terraform
* depends_on [
*   module.storage
* ]
* ```
*  
* ## Basic
* 
* ```terraform
* module "keyvault" {
*   source          = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-keyvault"
*   environment = "dev"
*   application = "app"
*   location    = "northeurope"
*   access_policies = [
*       {
*       user_principal_names = ["fred.bloggs@hiscox.com","joe.public@hiscox.com"]
*       secret_permissions   = ["get","set","list"]
*       },
*       {
*       group_names             = ["ClusterAdmins"]
*       certificate_permissions = ["get","list","import"]
*       },
*   ]
*   secrets = {
*     the-secret = "A secret stored in the vault",
*     another-secret = "Another secret stored in the vault"
*   }
* }
* ```
*
* This will create a keyvault called `dvmyappkvne` in resource group `dev-myapp-kv-northeurope`.
* It will assign secret access rights to two users and certificate access to a group.
* See [the official documentation](https://www.terraform.io/docs/providers/azurerm/r/key_vault.html#certificate_permissions) for more info
* on the specific permissions that can be applied.
* It will add two secrets to the vault.  N.B.  The values will be retained on terraform.state, so ensure state is encrypted before storing.
*
* ## Certificate Authority integrated KeyVault
* 
* ```terraform
* module "keyvault" {
*   source                             = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-keyvault"
*   resource_group_name                = azurerm_resource_group.resource_group.name
*   environment                        = var.environment
*   application                        = var.application
*   location                           = var.location
*   ca_integration                     = true
*   issuer_name                        = local.issuer_name
*   provider_name                      = "DigiCert"
*   ca_org_id                          = var.digicert_org_id
*   ca_user                            = var.digicert_api_user
*   ca_secret                          = var.digicert_api_password
*   admin_email                        = var.admin_email
*   admin_firstname                    = var.admin_firstname
*   admin_lastname                     = var.admin_lastname
*   admin_phone                        = var.admin_phone
* }
*
* This will create a KeyVault which is integrated with DigiCert for the issuing of publicly signed TLS/SSL certificates.
* The "azurerm_key_vault_certificate" Terraform resource can be used to define the certificates
*
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: [terraform-docs](https://github.com/segmentio/terraform-docs)
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

// if you do not specify an existing resurce group one will be created for you,
// when supplying the resource group name to a resource declaration you should use
// the data type i.e 'data.azurerm_resource_group.rg.name'
resource "azurerm_resource_group" "rg" {
  count    = var.resource_group_name == "" ? 1 : 0
  name     = "${var.environment}-${var.application}-keyvault-${var.location}"
  location = var.location
  tags     = local.tags
}

resource "azurerm_key_vault" "key_vault" {
  # Key Vault instance names can be a max of 24 chars long and only contain alphanumerics
  # The name expression removes any non-alphanumeric chars from the concatenation of environment, application, the string "kv" and the shortened location
  # and then truncates to 24 characters if necessary
  name                            = substr(replace(join("", [var.enable_user_supplied_environment != "true" ? local.environment_codes[var.environment] : var.environment, var.application, "kv", local.location_codes[var.location]]), "/\\W/", ""), 0, 24)
  resource_group_name             = data.azurerm_resource_group.rg.name
  location                        = var.location
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  soft_delete_retention_days      = var.soft_delete_retention_days
  purge_protection_enabled        = local.purge_protection_enabled
  sku_name                        = var.vault_sku
  tags                            = local.tags

  network_acls {
    bypass                     = "AzureServices"
    default_action             = "Deny"
    ip_rules                   = var.ip_rules
    virtual_network_subnet_ids = concat(local.cicd_subnet_ids, var.subnet_ids)
  }

  access_policy = concat(local.combined_access_policies, local.self_permissions)

  lifecycle {
    ignore_changes = [
      soft_delete_retention_days,
      purge_protection_enabled
    ]
  }
}

resource "azurerm_key_vault_secret" "secret" {
  for_each     = var.secrets
  name         = each.key
  value        = sensitive(each.value)
  key_vault_id = azurerm_key_vault.key_vault.id
  lifecycle {
    ignore_changes = [
      value
    ]
  }
}

data "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  count               = var.enable_diagnostics == "true" && var.enable_law_diagnostics ? 1 : 0
  name                = var.log_analytics_name
  resource_group_name = var.log_analytics_rg
}

data "azurerm_storage_account" "storage_account" {
  count               = var.enable_diagnostics == "true" && var.enable_storage_account_diagnostics ? 1 : 0
  name                = var.storage_account_name
  resource_group_name = var.storage_account_rg
}

resource "azurerm_monitor_diagnostic_setting" "key_vault_diagnostics" {
  count                      = var.enable_diagnostics == "true" ? 1 : 0
  name                       = "audits-allmetrics"
  target_resource_id         = azurerm_key_vault.key_vault.id
  storage_account_id         = var.enable_diagnostics == "true" && var.enable_storage_account_diagnostics ? data.azurerm_storage_account.storage_account[0].id : null
  log_analytics_workspace_id = var.enable_diagnostics == "true" && var.enable_law_diagnostics ? data.azurerm_log_analytics_workspace.log_analytics_workspace[0].id : null
  log {
    category = "AuditEvent"
    enabled  = true
    retention_policy {
      enabled = var.enable_audit_event_retention_policy
      days    = var.enable_audit_event_retention_policy ? var.audit_event_retention_days : 0
    }
  }
  metric {
    category = "AllMetrics"
    retention_policy {
      enabled = var.enable_all_metrics_retention_policy
      days    = var.enable_all_metrics_retention_policy ? var.all_metrics_retention_days : 0
    }
  }
}

resource "azurerm_key_vault_certificate_issuer" "certificate-issuer" {
  count         = var.ca_integration ? 1 : 0
  name          = var.issuer_name
  key_vault_id  = azurerm_key_vault.key_vault.id
  provider_name = var.provider_name
  org_id        = var.ca_org_id
  account_id    = var.ca_user
  password      = sensitive(var.ca_secret)

  admin {
    email_address = var.admin_email
    first_name    = var.admin_firstname
    last_name     = var.admin_lastname
    phone         = var.admin_phone
  }

  depends_on = [
    azurerm_key_vault.key_vault
  ]
}