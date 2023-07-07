/*
    Terraform configuration file defining outputs
*/

output "resource_group_name" {
  description = "Name of the resource group where resources have been deployed to"
  value       = data.azurerm_resource_group.rg.name
}

output "postgresql_server_name" {
  description = "Name of the PostgreSQL Server"
  value       = azurerm_postgresql_server.postgresql_server.name
}

output "postgresql_server_fqdn" {
  description = "FQDN of the PostgreSQL Server"
  value       = azurerm_postgresql_server.postgresql_server.fqdn
}
