module "azure_front_door" {
  source = "../"

  domain_name       = var.domain_name
  common_tags       = var.common_tags
  environment       = var.environment
  frontend_endpoint = var.frontend_endpoint
  location          = var.location
  name              = var.name
  sku_name          = var.sku_name


  providers = {
    azurerm         = azurerm
    azurerm.tooling = azurerm.tooling
  }
}
