/*
    Terraform configuration file defining outputs
*/

output "resource_group_name" {
  description = "Name of the resource group where resources have been deployed to"
  value       = data.azurerm_resource_group.rg.name
}

output "id" {
  description = "The ID of the Logic App"
  value       = azurerm_logic_app_standard.las.id
}

output "default_hostname" {
  description = "The default hostname of the logic app"
  value       = azurerm_logic_app_standard.las.default_hostname
}