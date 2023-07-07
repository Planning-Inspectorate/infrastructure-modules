/*
    Terraform configuration file defining data elements
*/

resource "time_static" "t" {}

data "azurerm_key_vault" "kv" {
  name                = var.key_vault_name
  resource_group_name = var.key_vault_rg
}

data "azurerm_key_vault_secret" "ad_sql_service_account_password" {
  name         = "svc-${var.environment}-exsql-tfsql"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_log_analytics_workspace" "law" {
  name                = var.log_analytics_name
  resource_group_name = var.log_analytics_resource_group
}