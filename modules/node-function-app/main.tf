resource "azurerm_linux_function_app" "function_app" {
  name                          = "pins-func-${var.service_name}-${var.app_name}-${var.resource_suffix}"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  service_plan_id               = var.app_service_plan_id
  storage_account_name          = var.function_apps_storage_account
  storage_account_access_key    = var.function_apps_storage_account_access_key
  https_only                    = true
  public_network_access_enabled = false

  app_settings = merge(
    var.app_settings,
    local.app_settings
  )

  dynamic "connection_string" {
    for_each = var.connection_strings

    content {
      name  = connection_string.value["name"]
      type  = connection_string.value["type"]
      value = connection_string.value["value"]
    }
  }

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on     = true
    http2_enabled = true

    application_stack {
      node_version = var.function_node_version
    }

    application_insights_key = var.use_app_insights ? azurerm_application_insights.function_app_insights.instrumentation_key : null
  }

  tags = var.tags

  virtual_network_subnet_id = var.outbound_vnet_connectivity ? var.integration_subnet_id : null
}

resource "azurerm_application_insights" "function_app_insights" {
  name                = "pins-func-${var.service_name}-${var.app_name}-${var.resource_suffix}-app-insights"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
}
