module "node_app_service" {
  source = "../"

  action_group_ids                         = var.action_group_ids
  app_name                                 = var.app_name
  app_service_plan_id                      = var.app_service_plan_id
  function_apps_storage_account            = var.function_apps_storage_account
  function_apps_storage_account_access_key = var.function_apps_storage_account_access_key
  location                                 = var.location
  log_analytics_workspace_id               = var.log_analytics_workspace_id
  monitoring_alerts_enabled                = var.monitoring_alerts_enabled
  resource_group_name                      = var.resource_group_name
  resource_suffix                          = var.resource_suffix
  service_name                             = var.service_name
  tags                                     = var.tags
  use_app_insights                         = var.use_app_insights
}
