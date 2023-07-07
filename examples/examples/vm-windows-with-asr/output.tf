/*
    Terraform configuration file defining outputs
*/

// Name of the resource group where resources have been deployed to
output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "vm_windows_metadata" {
  value = module.vm.windows_machine_metadata
}