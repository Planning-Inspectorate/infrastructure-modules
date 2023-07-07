

resource "random_string" "storage_name" {
  length  = 24
  special = false
  upper   = false
}

resource "azurerm_storage_account" "storage" {
  name                      = random_string.storage_name.result
  resource_group_name       = data.azurerm_resource_group.rg.name
  location                  = var.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  account_kind              = "StorageV2"
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"
  access_tier               = "Hot"
  is_hns_enabled            = false
  allow_blob_public_access  = false

  identity {
    type = "SystemAssigned"
  }

  dynamic "blob_properties" {
    for_each = local.storage_soft_delete_retention_policy == true ? toset([1]) : toset([])
    
    content {
      delete_retention_policy {
        days = 90
      }
      container_delete_retention_policy {
        days = 90
      }
    }
  }

  tags = local.tags
}

resource "azurerm_storage_account_network_rules" "storage-network-rule" {
  resource_group_name        = data.azurerm_resource_group.rg.name
  storage_account_name       = azurerm_storage_account.storage.name
  default_action             = var.network_default_action
  ip_rules                   = var.network_rule_ips
  virtual_network_subnet_ids = var.network_rule_virtual_network_subnet_ids_include_cicd_agents ? concat(local.cicd_subnet_ids, var.network_rule_virtual_network_subnet_ids) : var.network_rule_virtual_network_subnet_ids
  bypass                     = ["AzureServices", "Logging", "Metrics"]
}

resource "azurerm_storage_container" "container" {
  for_each              = toset(var.container_name)
  name                  = each.key
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = var.container_access_type //TODO: this needs to be a list
}

resource "azurerm_role_assignment" "blob_contributor" {
  scope                = azurerm_storage_account.storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_mssql_server.sql_server.identity[0].principal_id
}
