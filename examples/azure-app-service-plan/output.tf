/*
    Terraform configuration file defining outputs
*/

output "resource_group_name" {
  description = "Name of the resource group where resources have been deployed to"
  value       = data.azurerm_resource_group.rg.name
}

output "id" {
  description = "The ID of the App Service Plan."
  value       = azurerm_app_service_plan.asp.id
}

output "name" {
  description = "The nsame of the ASP"
  value       = azurerm_app_service_plan.asp.name
}