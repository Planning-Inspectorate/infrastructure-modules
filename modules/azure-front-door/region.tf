module "azure_region_uks" {
  source  = "claranet/regions/azurerm"
  version = "5.1.0"

  azure_region = var.location
}
