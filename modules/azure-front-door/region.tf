module "azure_region_ukw" {
  source  = "claranet/regions/azurerm"
  version = "4.2.1"

  azure_region = var.location
}
