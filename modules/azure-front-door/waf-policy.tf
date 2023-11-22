resource "azurerm_cdn_frontdoor_firewall_policy" "default" {
  name                              = var.name
  resource_group_name               = var.resource_group_name
  sku_name                          = azurerm_cdn_frontdoor_profile.default.sku_name
  enabled                           = true
  mode                              = var.front_door_waf_mode
  custom_block_response_status_code = 429

  tags = var.common_tags
}

resource "azurerm_cdn_frontdoor_security_policy" "default" {
  name                     = var.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.default.id

  security_policies {
    firewall {
      cdn_frontdoor_firewall_policy_id = azurerm_cdn_frontdoor_firewall_policy.default.id

      association {
        domain {
          cdn_frontdoor_domain_id = azurerm_cdn_frontdoor_custom_domain.default.id
        }
        patterns_to_match = ["/*"]
      }
    }
  }
}
