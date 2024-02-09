resource "azurerm_monitor_diagnostic_setting" "web_app_logs" {
  name                       = "AppServiceLogs"
  log_analytics_workspace_id = var.log_analytics_workspace_id
  target_resource_id         = azurerm_linux_web_app.web_app.id

  enabled_log {
    category = "AppServiceConsoleLogs"
  }

  metric {
    category = "AllMetrics"
  }

  lifecycle {
    ignore_changes = [
      log,
      metric
    ]
  }
}

resource "azurerm_monitor_metric_alert" "app_service_http_5xx" {
  name                = "Http 5xx - ${reverse(split("/", azurerm_linux_web_app.web_app.id))[0]}"
  resource_group_name = var.resource_group_name
  enabled             = var.monitoring_alerts_enabled
  scopes              = [azurerm_linux_web_app.web_app.id]
  description         = "Sends an alert when the App Service returns excess 5xx respones"
  window_size         = "PT5M"
  frequency           = "PT1M"
  severity            = 4
  tags                = var.tags

  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "Http5xx"
    aggregation      = "Average"
    operator         = "GreaterThanOrEqual"
    threshold        = 10
  }

  action {
    action_group_id = var.action_group_ids.tech
  }
}

resource "azurerm_monitor_metric_alert" "app_service_response_time" {
  name                = "Response Time - ${reverse(split("/", azurerm_linux_web_app.web_app.id))[0]}"
  resource_group_name = var.resource_group_name
  enabled             = var.monitoring_alerts_enabled
  scopes              = [azurerm_linux_web_app.web_app.id]
  description         = "Sends an alert when the App Service response exceeds 1 minute"
  window_size         = "PT5M"
  frequency           = "PT1M"
  severity            = 4
  tags                = var.tags

  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "HttpResponseTime"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 60
  }

  action {
    action_group_id = var.action_group_ids.tech
  }
}

resource "azurerm_monitor_activity_log_alert" "app_service_stop" {
  name                = "App Service Stopped - ${reverse(split("/", azurerm_linux_web_app.web_app.id))[0]}"
  resource_group_name = var.resource_group_name
  enabled             = var.monitoring_alerts_enabled
  scopes              = [azurerm_linux_web_app.web_app.id]
  description         = "Sends an alert when the App Service is stopped"
  tags                = var.tags

  criteria {
    resource_id    = azurerm_linux_web_app.web_app.id
    category       = "Administrative"
    operation_name = "Microsoft.Web/sites/stop/Action"
  }

  action {
    action_group_id = var.action_group_ids.tech
  }

  action {
    action_group_id = var.action_group_ids.service_manager
  }

  action {
    action_group_id = var.action_group_ids.its
  }

  action {
    action_group_id = var.action_group_ids.iap
  }
}

resource "azurerm_monitor_activity_log_alert" "app_service_delete" {
  name                = "App Service Deleted - ${reverse(split("/", azurerm_linux_web_app.web_app.id))[0]}"
  resource_group_name = var.resource_group_name
  enabled             = var.monitoring_alerts_enabled
  scopes              = [azurerm_linux_web_app.web_app.id]
  description         = "Sends an alert when the App Service is deleted"
  tags                = var.tags

  criteria {
    resource_id    = azurerm_linux_web_app.web_app.id
    category       = "Administrative"
    operation_name = "Microsoft.Web/sites/Delete"
  }

  action {
    action_group_id = var.action_group_ids.tech
  }

  action {
    action_group_id = var.action_group_ids.service_manager
  }

  action {
    action_group_id = var.action_group_ids.its
  }

  action {
    action_group_id = var.action_group_ids.iap
  }
}
