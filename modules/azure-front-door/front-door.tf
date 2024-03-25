resource "azurerm_cdn_frontdoor_profile" "default" {
  name                = var.name
  resource_group_name = azurerm_resource_group.frontdoor.name
  sku_name            = var.sku_name

  tags = local.tags
}

resource "azurerm_cdn_frontdoor_endpoint" "default" {
  name                     = var.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.default.id

  tags = local.tags
}

resource "azurerm_cdn_frontdoor_origin_group" "default" {
  name                     = var.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.default.id
  session_affinity_enabled = false

  health_probe {
    interval_in_seconds = 240
    path                = "/"
    protocol            = "Https"
    request_type        = "HEAD"
  }

  load_balancing {
    additional_latency_in_milliseconds = 0
    sample_size                        = 16
    successful_samples_required        = 3
  }
}

resource "azurerm_cdn_frontdoor_origin" "default" {
  for_each                      = var.origin
  name                          = each.key
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.default[each.key].id

  enabled                        = each.value.enabled
  host_name                      = var.frontend_endpoint
  http_port                      = each.value.http_port
  https_port                     = each.value.https_port
  origin_host_header             = var.frontend_endpoint
  priority                       = each.value.priority
  weight                         = each.value.weight
  certificate_name_check_enabled = each.value.certificate_name_check_enabled
}

resource "azurerm_cdn_frontdoor_route" "default" {
  for_each                      = var.route
  name                          = each.key
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.default[each.key].id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.default[each.key].id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.default[each.key].id]

  forwarding_protocol = each.value.forwarding_protocol
  patterns_to_match   = each.value.patterns_to_match
  supported_protocols = each.value.forwarding_protocol

  https_redirect_enabled = each.value.https_redirect_enabled
  link_to_default_domain = each.value.link_to_default_domain
}

resource "azurerm_cdn_frontdoor_custom_domain" "default" {
  name                     = var.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.default.id
  host_name                = var.domain_name


  tls {
    certificate_type    = "ManagedCertificate"
    minimum_tls_version = "TLS12"
  }
}

resource "azurerm_cdn_frontdoor_custom_domain_association" "default" {
  cdn_frontdoor_custom_domain_id = azurerm_cdn_frontdoor_custom_domain.default.id
  cdn_frontdoor_route_ids        = [azurerm_cdn_frontdoor_route.default[0].id]
}
