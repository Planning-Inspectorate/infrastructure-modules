/*
    Terraform configuration file defining outputs
*/

output "resource_group_name" {
  description = "Name of the resource group where resources have been deployed to"
  value       = data.azurerm_resource_group.rg.name
}


output "sql_server_name" {
  description = "Name of the SQL instance"
  value       = azurerm_mssql_server.sql_server.name
}

output "sql_server_name_fqdn" {
  description = "Name of the SQL instance"
  value       = azurerm_mssql_server.sql_server.fully_qualified_domain_name
}


output "sql_server_id" {
  description = "ID os the SQL instance"
  value       = azurerm_mssql_server.sql_server.id
}


output "sql_admin_login" {
  description = "Name of the SQL administrator login"
  value       = local.administrator_login_name
}

output "admin_ad_account" {
  description = "AD admin account (service account)"
  value       = local.ad_sql_service_account
}

output "elastic_pool_id" {
  # Workaround so the output is a string instead of a list
  description = "Id of the elastic pool on North Europe"
  value       = element(concat(azurerm_mssql_elasticpool.pool.*.id, [""]), 0)
}

output "pool_db_data" {
  description = "Map of the pool databases"
  value       = azurerm_mssql_database.pool_database
}

output "pool_db_ids" {
  description = "List of pool database IDs"
  value       = [for k, v in azurerm_mssql_database.pool_database : v.id]
}

output "standalone_db_data" {
  description = "Map of the standalone databases"
  value       = azurerm_mssql_database.database
}

output "standalone_db_ids" {
  description = "List of standalone database IDs"
  value       = [for k, v in azurerm_mssql_database.database : v.id]
}

output "standalone_db_names" {
  description = "List of standalone database Names"
  value       = [for k, v in azurerm_mssql_database.database : v.name]
}

output "sql_admin_server_password" {
  description = "Local SQL admin user password output so it can be saved on Keyvault"
  value       = local.sql_server_admin_password
  sensitive   = true
}

output "storage_name" {
  description = "Name of the storage account used for sql"
  value       = azurerm_storage_account.storage.name
}

output "storage_id" {
  description = "ID of the storage account used for sql"
  value       = azurerm_storage_account.storage.id
}
