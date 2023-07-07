/*
    Terraform configuration file defining outputs
*/

output "resource_group_name" {
  description = "Name of the resource group where resources have been deployed to"
  value       = data.azurerm_resource_group.rg.name
}

output "acr_id" {
  description = "ID of the ACR"
  value       = azurerm_container_registry.acr.id
}

output "acr_url" {
  description = "The login URL to access the ACR"
  value       = azurerm_container_registry.acr.login_server
}

output "acr_username" {
  description = "The admin username to access the ACR"
  value       = azurerm_container_registry.acr.admin_username
}

output "acr_password" {
  description = "The admin password to access the ACR"
  value       = azurerm_container_registry.acr.admin_password
  sensitive   = true
}