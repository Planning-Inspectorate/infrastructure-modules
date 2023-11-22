resource "azurerm_cdn_frontdoor_rule_set" "default" {
  name                     = var.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.default.id
}
