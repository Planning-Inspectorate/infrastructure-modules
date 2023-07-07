/*
    Terraform configuration file defining outputs
*/

output "resource_group_name_primary" {
  description = "Name of the resource group where resources have been deployed to"
  value       = azurerm_resource_group.rg_primary.name
}

output "resource_group_name_secondary" {
  description = "Name of the resource group where resources have been deployed to"
  value       = azurerm_resource_group.rg_secondary.name
}
