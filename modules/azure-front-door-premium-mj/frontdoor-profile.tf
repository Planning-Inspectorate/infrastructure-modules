# Taken from afd-module
resource "azurerm_cdn_frontdoor_profile" "profile" {
  name = var.name # link this to the environment too so read dev.frontdoor...

  resource_group_name = var.resource_group_name
  # resource_group_name = data.azurerm_resource_group.current.name
  sku_name = var.sku_name # sku_name = "${title(var.tier)}_AzureFrontDoor"

  tags = merge(
    local.common_tags,
    # var.additional_tags_all,
    # var.additional_tags
  )
}

# ---------
# Endpoints
# ---------
resource "azurerm_cdn_frontdoor_endpoint" "endpoints" {
  for_each = var.endpoints

  name                     = each.key
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.profile.id
  enabled                  = each.value.enabled

  tags = merge(
    local.common_tags,
    # var.additional_tags_all,
    # each.value.additional_tags
  )
}

resource "azurerm_cdn_frontdoor_origin_group" "cdn_frontdoor_origin_group" {
  for_each = var.origin_groups

  name                     = each.key
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.profile.id

  session_affinity_enabled = each.value.session_affinity_enabled

  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 30
  dynamic "health_probe" {
    for_each = each.value.health_probe == null ? [] : ["enabled"]
    content {
      interval_in_seconds = each.value.health_probe.interval_in_seconds # MUST BE MOST 255
      path                = each.value.health_probe.path
      protocol            = each.value.health_probe.protocol
      request_type        = each.value.health_probe.request_type
    }
  }

  load_balancing {
    additional_latency_in_milliseconds = each.value.load_balancing.additional_latency_in_milliseconds
    sample_size                        = each.value.load_balancing.sample_size
    successful_samples_required        = each.value.load_balancing.successful_samples_required
  }
}

# data "azurerm_resource_group" "current" {
#   name = var.azure.resource_group_name
# }
