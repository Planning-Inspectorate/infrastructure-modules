output "frontend_endpoints" {
  description = "A map of frontend endpoints within the Front Door instance"
  value       = azurerm_cdn_frontdoor_endpoint.default[0].name
}
