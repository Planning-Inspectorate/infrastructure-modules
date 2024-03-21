resource "azurerm_log_analytics_workspace" "frontdoor" {
  name                = var.name
  resource_group_name = azurerm_resource_group.frontdoor.name
  location            = azurerm_resource_group.frontdoor.location
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = local.tags
}

resource "azurerm_monitor_diagnostic_setting" "frontdoor" {
  name                       = var.name
  target_resource_id         = azurerm_cdn_frontdoor_profile.default.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.frontdoor.id

  enabled_log {
    category = "FrontdoorWebApplicationFirewallLog"
  }

  metric {
    category = "AllMetrics"
  }

  lifecycle {
    ignore_changes = [
      enabled_log,
      metric
    ]
  }
}
