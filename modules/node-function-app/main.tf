resource "azurerm_linux_function_app" "function_app" {
  #TODO: Private Endpoints
  #checkov:skip=CKV_AZURE_221: Ensure that Azure Function App public network access is disabled
  name                          = "pins-func-${var.service_name}-${var.app_name}-${var.resource_suffix}"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  service_plan_id               = var.app_service_plan_id
  storage_account_name          = var.function_apps_storage_account
  storage_account_access_key    = var.function_apps_storage_account_access_key
  https_only                    = true
  public_network_access_enabled = !var.inbound_vnet_connectivity

  app_settings = merge(
    local.app_settings,
    var.app_settings # passed in settings take precedence
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

    application_insights_key = var.app_insights_instrument_key
  }

  tags = var.tags

  virtual_network_subnet_id = var.outbound_vnet_connectivity ? var.integration_subnet_id : null
}

# setup key vault read access if configured
resource "azurerm_key_vault_access_policy" "read_secrets" {
  count = var.key_vault_id != null ? 1 : 0

  key_vault_id = var.key_vault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_linux_function_app.function_app.identity[0].principal_id

  certificate_permissions = []
  key_permissions         = []
  secret_permissions      = ["Get"]
  storage_permissions     = []
}
