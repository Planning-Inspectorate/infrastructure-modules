locals {
  service_name    = "common"
  resource_suffix = "${var.environment}-${var.instance}"

  applications_primary_mapping = {
    url      = var.applications_service_primary_app_service_url,
    priority = 1
  }

  applications_secondary_mapping = {
    url      = var.applications_service_secondary_app_service_url,
    priority = 0
  }

  back_office_primary_mapping = {
    url      = var.back_office_primary_app_service_url,
    priority = 1
  }

  back_office_secondary_mapping = {
    url      = var.back_office_secondary_app_service_url,
    priority = 0
  }

  appeals_primary_mapping = {
    url      = var.appeals_service_primary_app_service_url,
    priority = 1
  }

  appeals_secondary_mapping = {
    url      = var.appeals_service_secondary_app_service_url,
    priority = 0
  }

  back_office_appeals_primary_mapping = {
    url      = var.back_office_appeals_primary_app_service_url,
    priority = 1
  }

  back_office_appeals_secondary_mapping = {
    url      = var.back_office_appeals_secondary_app_service_url,
    priority = 0
  }

  applications_frontend = {
    frontend_endpoint = var.applications_service_public_url
    app_service_urls = local.applications_secondary_mapping.url != "" && var.feature_front_door_failover_enaled ? [
      local.applications_primary_mapping,
      local.applications_secondary_mapping] : [
      local.applications_primary_mapping
    ]
    infer_backend_host_header = false
    name                      = "ApplicationsService"
    frontend_name             = "ApplicationsService"
    patterns_to_match         = ["/*"]
    ssl_certificate_name      = var.applications_service_ssl_certificate_name
  }

  back_office_frontend = {
    frontend_endpoint = var.back_office_public_url
    app_service_urls = local.back_office_secondary_mapping.url != "" && var.feature_front_door_failover_enaled ? [
      local.back_office_primary_mapping,
      local.back_office_secondary_mapping] : [
      local.back_office_primary_mapping
    ]
    infer_backend_host_header = false
    name                      = "BackOffice"
    frontend_name             = "BackOffice"
    patterns_to_match         = ["/*"]
    ssl_certificate_name      = var.back_office_ssl_certificate_name
  }

  appeals_frontend = {
    frontend_endpoint = var.appeals_service_public_url
    app_service_urls = local.appeals_secondary_mapping.url != "" && var.feature_front_door_failover_enaled ? [
      local.appeals_primary_mapping,
      local.appeals_secondary_mapping] : [
      local.appeals_primary_mapping
    ]
    infer_backend_host_header = false
    name                      = "AppealsService"
    frontend_name             = "appeal-planning-decision-service-gov-uk"
    patterns_to_match         = ["/*"]
    ssl_certificate_name      = var.appeals_service_ssl_certificate_name
  }

  back_office_appeals_frontend = {
    frontend_endpoint = var.back_office_appeals_public_url
    app_service_urls = local.back_office_appeals_secondary_mapping.url != "" && var.feature_front_door_failover_enaled ? [
      local.back_office_appeals_primary_mapping,
      local.back_office_appeals_secondary_mapping] : [
      local.back_office_appeals_primary_mapping
    ]
    infer_backend_host_header = false
    name                      = "BackOfficeAppeals"
    frontend_name             = "BackOfficeAppeals"
    patterns_to_match         = ["/*"]
    ssl_certificate_name      = var.back_office_appeals_ssl_certificate_name
  }

  frontend_endpoint_mappings = [{
    name            = "ApplicationsService"
    search_indexing = var.enable_search_indexing_by_default
    }, {
    name            = "BackOffice"
    search_indexing = false
    }, {
    name            = "AppealsService"
    search_indexing = false
    }, {
    name            = "BackOfficeAppeals"
    search_indexing = false
  }]

  # This variable is used in a bash script to loop through some Azure CLI commands that cannot conflict
  # We cannot use a terraform for_each loop for the null_resource since these all run in parallel. Hence the loop is done within the command
  # Bash requires a space separate string to loop through.
  search_indexing_rule_backends = join(" ", [for mapping in local.frontend_endpoint_mappings : mapping["name"] if mapping["search_indexing"] == false])

  tags = merge(
    var.common_tags,
    {
      ServiceName = local.service_name
      Region      = "Global"
    }
  )
}
