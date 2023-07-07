/*
    Terraform configuration file defining outputs
*/

// Name of the resource group where resources have been deployed to
output "resource_group_name" {
  value = azurerm_resource_group.gateway.name
}
