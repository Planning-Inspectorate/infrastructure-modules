module "azure_front_door" {
  source = "../../azure-front-door"

  cdn_frontdoor_origin_path         = var.cdn_frontdoor_origin_path
  common_tags                       = var.common_tags
  common_log_analytics_workspace_id = var.common_log_analytics_workspace_id
  name                              = var.name
  host_name                         = var.host_name
  resource_group_name               = var.resource_group_name
  service_name                      = var.service_name
}
