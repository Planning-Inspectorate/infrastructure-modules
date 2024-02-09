resource "azurerm_monitor_diagnostic_setting" "function_app_logs" {
  name                       = "Function App Logs"
  log_analytics_workspace_id = var.log_analytics_workspace_id
  target_resource_id         = azurerm_linux_function_app.function_app.id

  enabled_log {
    category = "FunctionAppLogs"
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

resource "azurerm_monitor_metric_alert" "function_app_http_5xx" {
  name                = "Http 5xx - ${reverse(split("/", azurerm_linux_function_app.function_app.id))[0]}"
  resource_group_name = var.resource_group_name
  enabled             = var.monitoring_alerts_enabled
  scopes              = [azurerm_linux_function_app.function_app.id]
  description         = "Sends an alert when the Function App returns excess 5xx respones"
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

resource "azurerm_monitor_metric_alert" "function_app_response_time" {
  name                = "Response Time - ${reverse(split("/", azurerm_linux_function_app.function_app.id))[0]}"
  resource_group_name = var.resource_group_name
  enabled             = var.monitoring_alerts_enabled
  scopes              = [azurerm_linux_function_app.function_app.id]
  description         = "Sends an alert when the Function App response exceeds 1 minute"
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

resource "azurerm_monitor_activity_log_alert" "function_app_stop" {
  name                = "Function App Stopped - ${reverse(split("/", azurerm_linux_function_app.function_app.id))[0]}"
  resource_group_name = var.resource_group_name
  enabled             = var.monitoring_alerts_enabled
  scopes              = [azurerm_linux_function_app.function_app.id]
  description         = "Sends an alert when the Function App is stopped"
  tags                = var.tags

  criteria {
    resource_id    = azurerm_linux_function_app.function_app.id
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

resource "azurerm_monitor_activity_log_alert" "function_app_delete" {
  name                = "Function App Deleted - ${reverse(split("/", azurerm_linux_function_app.function_app.id))[0]}"
  resource_group_name = var.resource_group_name
  enabled             = var.monitoring_alerts_enabled
  scopes              = [azurerm_linux_function_app.function_app.id]
  description         = "Sends an alert when the Function App is deleted"
  tags                = var.tags

  criteria {
    resource_id    = azurerm_linux_function_app.function_app.id
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
