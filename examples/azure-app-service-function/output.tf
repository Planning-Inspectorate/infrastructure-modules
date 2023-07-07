/*
    Terraform configuration file defining outputs
*/

output "resource_group_name" {
  description = "Name of the resource group where resources have been deployed to"
  value       = data.azurerm_resource_group.rg.name
}

output "name" {
  description = "Name of the function app"
  value       = azurerm_function_app.function[*].name
}

output "id" {
  description = "Id of the function app"
  value       = azurerm_function_app.function[*].id
}

output "hostname" {
  description = "Id of the function app"
  value       = azurerm_function_app.function[*].default_hostname
}

output "identity" {
  description = "Identity block function app managed identity"
  value       = azurerm_function_app.function[*].identity //.principal_id - 
}
