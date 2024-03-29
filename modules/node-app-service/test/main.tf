module "node_app_service" {
  source = "../"

  action_group_ids                      = var.action_group_ids
  app_name                              = var.app_name
  app_service_plan_id                   = var.app_service_plan_id
  app_service_plan_resource_group_name  = var.app_service_plan_resource_group_name
  app_service_private_dns_zone_id       = var.app_service_private_dns_zone_id
  app_settings                          = var.app_settings
  container_registry_name               = var.container_registry_name
  container_registry_rg                 = var.container_registry_rg
  custom_hostname                       = var.custom_hostname
  custom_hostname_certificate_secret_id = var.custom_hostname_certificate_secret_id
  endpoint_subnet_id                    = var.endpoint_subnet_id
  health_check_path                     = var.health_check_path
  image_name                            = var.image_name
  inbound_vnet_connectivity             = var.inbound_vnet_connectivity
  integration_subnet_id                 = var.integration_subnet_id
  key_vault_id                          = var.key_vault_id
  location                              = var.location
  log_analytics_workspace_id            = var.log_analytics_workspace_id
  monitoring_alerts_enabled             = var.monitoring_alerts_enabled
  outbound_vnet_connectivity            = var.outbound_vnet_connectivity
  resource_group_name                   = var.resource_group_name
  resource_suffix                       = var.resource_suffix
  service_name                          = var.service_name
  tags                                  = var.tags

  providers = {
    azurerm         = azurerm
    azurerm.tooling = azurerm.tooling
  }
}
