/*
    Terraform configuration file defining outputs
*/

output "resource_group_name" {
  description = "Name of the resource group where resources have been deployed to"
  value       = data.azurerm_resource_group.rg.name
}

output "data_factory_id" {
  description = "The ID of the data factory instance"
  value       = azurerm_data_factory.df.id
}

output "data_factory_name" {
  description = "The name of the data factory instance"
  value       = azurerm_data_factory.df.name
}

output "datafactory_msi_object_id" {
  description = "Data factory Managed Service Identity principal id"
  value       = azurerm_data_factory.df.identity[0].principal_id
}

output "integration_runtime_name" {
  description = "The name of the IR"
  value       = azurerm_data_factory_integration_runtime_managed.irm[*].name
}

output "linked_sql_server_id" {
  description = "Map of linked sql IDs"
  value       = azurerm_data_factory_linked_service_sql_server.sql
}

output "linked_blob_storage_id" {
  description = "Map of linked blob IDs"
  value       = azurerm_data_factory_linked_service_azure_blob_storage.blob
}

output "linked_file_storage_id" {
  description = "Map of linked file IDs"
  value       = azurerm_data_factory_linked_service_azure_file_storage.file
}

output "linked_key_vault_id" {
  description = "Map of linked kv IDs"
  value       = azurerm_data_factory_linked_service_key_vault.kv
}

