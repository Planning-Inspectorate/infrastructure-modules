/*
    Terraform configuration file defining data elements
*/

data "azurerm_private_dns_zone" "zone_storage" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.private_dns_zone_resource_group_name
  provider            = azurerm.platform
}

data "azurerm_private_dns_zone" "zone_kv" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.private_dns_zone_resource_group_name
  provider            = azurerm.platform
}