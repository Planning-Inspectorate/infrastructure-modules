resource "azurerm_resource_group" "frontdoor" {
  name     = var.name
  location = module.azure_region_uks.location

  tags = merge(
    local.tags,
    {
      Region = module.azure_region_uks.location
    }
  )
}
