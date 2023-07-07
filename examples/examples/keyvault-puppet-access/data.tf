/*
    Terraform configuration file defining data elements
*/

resource "time_static" "t" {}

data "azurerm_resources" "vm" {
  for_each            = var.puppetmaster_rg
  provider            = azurerm.platform
  resource_group_name = each.key
  type                = "Microsoft.Compute/virtualMachines"
}

data "azurerm_virtual_machine" "puppetmaster_vm" {
  for_each            = data.azurerm_resources.vm
  provider            = azurerm.platform
  name                = each.value.resources[0].name
  resource_group_name = each.value.resource_group_name
}