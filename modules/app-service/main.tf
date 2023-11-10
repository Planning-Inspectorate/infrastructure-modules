resource "azurerm_service_plan" "example" {
  name                = "example"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = var.os_type
  sku_name            = var.sku_name
}

resource "azurerm_linux_web_app" "example" {
  name                = "example"
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = var.app_service_plan_id

  site_config {}
}
