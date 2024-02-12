resource "azurerm_cdn_frontdoor_profile" "default" {
  for_each            = var.profile
  name                = each.key
  resource_group_name = each.value.resource_group_name
  sku_name            = each.value.sku_name

  tags = each.value.tags
}

resource "azurerm_cdn_frontdoor_endpoint" "default" {
  for_each                 = var.endpoints
  name                     = each.key
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.default[each.key].id

  tags = each.value.tags
}

resource "azurerm_cdn_frontdoor_origin_group" "default" {
  for_each                 = var.origin_groups
  name                     = each.key
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.default[each.key].id
  session_affinity_enabled = each.value.session_affinity_enabled

  dynamic "load_balancing" {
    for_each = each.value.load_balancing == null ? [] : ["enabled"]
    content {
      sample_size                        = each.value.sample_size
      successful_samples_required        = each.value.successful_samples_required
      additional_latency_in_milliseconds = each.value.additional_latency_in_milliseconds
    }
  }

  dynamic "health_probe" {
    for_each = each.value.health_probe == null ? [] : ["enabled"]
    content {
      path                = each.value.path
      protocol            = each.value.protocol
      request_type        = each.value.request_type
      interval_in_seconds = each.value.interval_in_seconds
    }
  }
}

resource "azurerm_cdn_frontdoor_origin" "default" {
  for_each                      = var.origins
  name                          = each.key
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.default[each.key].id

  enabled                        = each.value.enabled
  host_name                      = each.value.host_name
  http_port                      = each.value.http_port
  https_port                     = each.value.https_port
  origin_host_header             = each.value.origin_host_header
  priority                       = each.value.priority
  weight                         = each.value.weight
  certificate_name_check_enabled = each.value.certificate_name_check_enabled
}

resource "azurerm_cdn_frontdoor_route" "default" {
  for_each                      = var.routes
  name                          = each.key
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.default[each.key].id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.default[each.key].id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.default[each.key].id]

  forwarding_protocol = each.value.forwarding_protocol
  patterns_to_match   = each.value.patterns_to_match
  supported_protocols = each.value.forwarding_protocol

  https_redirect_enabled = each.value.https_redirect_enabled
  link_to_default_domain = each.value.link_to_default_domain

  cdn_frontdoor_origin_path = var.cdn_frontdoor_origin_path
}

resource "azurerm_cdn_frontdoor_custom_domain" "default" {
  for_each                 = var.custom_domain
  name                     = each.key
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.default[each.key].id
  host_name                = each.value.host_name

  dynamic "tls" {
    for_each = each.value.tls == null ? [] : ["enabled"]
    content {
      certificate_type    = each.value.certificate_type
      minimum_tls_version = each.value.minimum_tls_version
    }
  }
}
