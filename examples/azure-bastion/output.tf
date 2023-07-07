// Name of the resource group where resources have been deployed to
output "resource_group_name" {
  value = azurerm_resource_group.resource_group.name
}

// Name of the bastion
output "name" {
  value = local.name
}

