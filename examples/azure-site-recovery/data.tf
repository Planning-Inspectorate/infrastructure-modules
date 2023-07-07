/*
	Terraform configuration file defining data elements
*/

resource "time_static" "t" {}

data "azurerm_resource_group" "target_vnet_rg" {
  name = var.target_vnet_resource_group
}

data "azurerm_resource_group" "asr_rg" {
  name = var.asr_vault_rg
}

data "azurerm_storage_account" "asr-cache" {
  name                = var.cache_storage_account_name
  resource_group_name = var.cache_storage_account_rg
}

data "azurerm_site_recovery_fabric" "primary-fabric" {
  name                = var.asr_primary_fabric_name
  recovery_vault_name = var.asr_vault_name
  resource_group_name = var.asr_vault_rg
}

data "azurerm_site_recovery_fabric" "secondary-fabric" {
  name                = var.asr_secondary_fabric_name
  recovery_vault_name = var.asr_vault_name
  resource_group_name = var.asr_vault_rg
}

data "azurerm_site_recovery_protection_container" "primary-container" {
  name                 = var.asr_primary_protection_container_name
  recovery_vault_name  = var.asr_vault_name
  resource_group_name  = var.asr_vault_rg
  recovery_fabric_name = var.asr_primary_fabric_name
}

data "azurerm_site_recovery_protection_container" "secondary-container" {
  name                 = var.asr_secondary_protection_container_name
  recovery_vault_name  = var.asr_vault_name
  resource_group_name  = var.asr_vault_rg
  recovery_fabric_name = var.asr_secondary_fabric_name
}

data "azurerm_site_recovery_replication_policy" "policy" {
  name                = var.asr_policy_name
  recovery_vault_name = var.asr_vault_name
  resource_group_name = var.asr_vault_rg
}