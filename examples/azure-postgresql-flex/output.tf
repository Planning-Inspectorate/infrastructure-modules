/*
    Terraform configuration file defining outputs
*/

output "resource_group_name" {
  description = "Name of the resource group where resources have been deployed to"
  value       = data.azurerm_resource_group.rg.name
}

output "postgresqlflx_server_name" {
  description = "Name of the PostgreSQL Server"
  value       = azurerm_postgresql_flexible_server.postgresqlflx_server.name
}

output "postgresqlflx_server_fqdn" {
  description = "FQDN of the PostgreSQL Server"
  value       = azurerm_postgresql_flexible_server.postgresqlflx_server.fqdn
}

output "postgresqlflx_server_id" {
  description = "ID of the PostgreSQL Server"
  value       = azurerm_postgresql_flexible_server.postgresqlflx_server.id
}

output "public_access_enabled_value" {
  description = "check to see if public access is enabled"
  value       = azurerm_postgresql_flexible_server.postgresqlflx_server.public_network_access_enabled
}