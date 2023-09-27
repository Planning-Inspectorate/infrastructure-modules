resource "azurerm_resource_group" "frontdoor" {
  name     = var.resource_group_name
  location = module.azure_region.location

  tags = merge(
    local.tags,
    {
      Region = module.azure_region.location
    }
  )
}
