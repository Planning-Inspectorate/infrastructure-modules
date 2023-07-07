locals {
  public_ip_count = var.public_ip_address_allocation == "None" ? 0 : var.vm_count

  storage_soft_delete_retention_policy = var.storage_soft_delete_retention_policy == true || substr(var.environment, 0, 2) == "pr" ? true : var.storage_soft_delete_retention_policy

  cicd_subnet_ids = [
    "/subscriptions/bab9ed05-2c6e-4631-a0cf-7373c33838cc/resourceGroups/ExpressRoute-RG-TC1-01/providers/Microsoft.Network/virtualNetworks/Core-VN-01/subnets/bam-sn-01",
    "/subscriptions/bab9ed05-2c6e-4631-a0cf-7373c33838cc/resourceGroups/ExpressRoute-RG-TC1-01/providers/Microsoft.Network/virtualNetworks/Core-VN-01/subnets/vm-sn-01",
    "/subscriptions/c3dbe116-7ab5-4155-89c0-a81dcd9bfe9e/resourceGroups/production-its-subscription-northeurope/providers/Microsoft.Network/virtualNetworks/production-its-vnet-northeurope/subnets/production-itsaks-aks",
    "/subscriptions/c3dbe116-7ab5-4155-89c0-a81dcd9bfe9e/resourceGroups/production-its-subscription-westeurope/providers/Microsoft.Network/virtualNetworks/production-its-vnet-westeurope/subnets/production-itsaks-aks"
  ]
}

locals {
  # hack hack is a dummy array for passing to element() in the public_ip_address_id field
  # the split and join is a workaround for https://github.com/hashicorp/terraform/issues/12453
  public_ip_ids = split(
    " ",
    var.public_ip_address_allocation == "None" ? "hack hack" : join(" ", azurerm_public_ip.public_ip.*.id),
  )
}
