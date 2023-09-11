output "frontend_endpoint_mappings" {
  description = "A map of maps containing configuration options for each frontend endpoint"
  value = {
    applications_frontend = {
      frontend_name        = local.applications_frontend.frontend_name
      frontend_endpoint    = local.applications_frontend.frontend_endpoint
      patterns_to_match    = local.applications_frontend.patterns_to_match
      ssl_certificate_name = local.applications_frontend.ssl_certificate_name
    },
    back_office_frontend = {
      frontend_name        = local.back_office_frontend.frontend_name
      frontend_endpoint    = local.back_office_frontend.frontend_endpoint
      patterns_to_match    = local.back_office_frontend.patterns_to_match
      ssl_certificate_name = local.back_office_frontend.ssl_certificate_name
    },
    appeals_frontend = {
      frontend_name        = local.appeals_frontend.frontend_name
      frontend_endpoint    = local.appeals_frontend.frontend_endpoint
      patterns_to_match    = local.appeals_frontend.patterns_to_match
      ssl_certificate_name = local.appeals_frontend.ssl_certificate_name
    },
    back_office_appeals_frontend = {
      frontend_name        = local.back_office_appeals_frontend.frontend_name
      frontend_endpoint    = local.back_office_appeals_frontend.frontend_endpoint
      patterns_to_match    = local.back_office_appeals_frontend.patterns_to_match
      ssl_certificate_name = local.back_office_appeals_frontend.ssl_certificate_name
    }
  }
}

output "frontend_endpoints" {
  description = "A map of frontend endpoints within the Front Door instance"
  value       = azurerm_frontdoor.common.frontend_endpoints
}
