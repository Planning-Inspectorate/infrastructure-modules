/*
    Terraform configuration file defining outputs
*/

output "resource_group_name" {
  description = "Name of the resource group where resources have been deployed to"
  value       = azurerm_resource_group.rg.name
}
