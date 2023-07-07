/*
    Terraform configuration file defining provider configuration
*/
locals {
  tags = merge(
    tomap({
      application = var.application,
      environment = var.environment,
      repo        = "https://dev.azure.com/hiscox/gp-psg/_git/terraform-modules",
      created     = time_static.t.rfc3339
    }),
    var.tags,
  )

  cicd_subnet_ids = [
    "/subscriptions/bab9ed05-2c6e-4631-a0cf-7373c33838cc/resourceGroups/ExpressRoute-RG-TC1-01/providers/Microsoft.Network/virtualNetworks/Core-VN-01/subnets/bam-sn-01",
    "/subscriptions/bab9ed05-2c6e-4631-a0cf-7373c33838cc/resourceGroups/ExpressRoute-RG-TC1-01/providers/Microsoft.Network/virtualNetworks/Core-VN-01/subnets/vm-sn-01",
    "/subscriptions/c3dbe116-7ab5-4155-89c0-a81dcd9bfe9e/resourceGroups/production-its-subscription-northeurope/providers/Microsoft.Network/virtualNetworks/production-its-vnet-northeurope/subnets/production-itsaks-aks",
    "/subscriptions/c3dbe116-7ab5-4155-89c0-a81dcd9bfe9e/resourceGroups/production-its-subscription-westeurope/providers/Microsoft.Network/virtualNetworks/production-its-vnet-westeurope/subnets/production-itsaks-aks",
    "/subscriptions/bab9ed05-2c6e-4631-a0cf-7373c33838cc/resourceGroups/ExpressRoute-RG-TC1-01/providers/Microsoft.Network/virtualNetworks/Core-VN-01/subnets/prod-platform-aks-node-pool",
    "/subscriptions/bab9ed05-2c6e-4631-a0cf-7373c33838cc/resourceGroups/ExpressRoute-RG-TC2-01/providers/Microsoft.Network/virtualNetworks/Core-VN-01/subnets/prod-platform-aks-node-pool"
  ]

  soft_delete_retention_policy = var.soft_delete_retention_policy == true || substr(var.environment, 0, 2) == "pr" ? true : var.soft_delete_retention_policy

}
