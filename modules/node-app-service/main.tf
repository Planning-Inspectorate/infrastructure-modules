resource "azurerm_linux_web_app" "web_app" {
  #checkov:skip=CKV_AZURE_13: App Service authentication may not be required
  #checkov:skip=CKV_AZURE_17: Disabling FTP(S) to be tested
  #checkov:skip=CKV_AZURE_78: TLS mutual authentication may not be required
  #checkov:skip=CKV_AZURE_88: Azure Files mount may not be required
  #checkov:skip=CKV_AZURE_213: App Service health check may not be required
  #TODO: Private Endpoints
  #checkov:skip=CKV_AZURE_222: Ensure that Azure Web App public network access is disabled
  name                          = "pins-app-${var.service_name}-${var.app_name}-${var.resource_suffix}"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  service_plan_id               = var.app_service_plan_id
  client_certificate_enabled    = false
  https_only                    = true
  public_network_access_enabled = !var.inbound_vnet_connectivity

  app_settings = local.app_settings

  identity {
    type = "SystemAssigned"
  }

  logs {
    detailed_error_messages = true
    failed_request_tracing  = true

    http_logs {
      file_system {
        retention_in_days = 4
        retention_in_mb   = 25
      }
    }
  }

  site_config {
    always_on                         = true
    http2_enabled                     = true
    health_check_path                 = var.health_check_path
    health_check_eviction_time_in_min = var.health_check_eviction_time_in_min

    application_stack {
      docker_image_name        = "${var.image_name}:main"
      docker_registry_url      = "https://${data.azurerm_container_registry.acr.login_server}"
      docker_registry_password = sensitive(data.azurerm_container_registry.acr.admin_password)
      docker_registry_username = data.azurerm_container_registry.acr.admin_username
    }

    ip_restriction_default_action = var.front_door_restriction ? "Deny" : "Allow"
    dynamic "ip_restriction" {
      for_each = var.front_door_restriction ? [1] : []

      content {
        name        = "FrontDoorInbound"
        service_tag = "AzureFrontDoor.Backend"
        action      = "Allow"
        priority    = 100
      }
    }
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      site_config["application_stack"],
      # ignore any changes to "hidden-link" and other tags
      # see https://github.com/hashicorp/terraform-provider-azurerm/issues/16569
      tags
    ]
  }

  virtual_network_subnet_id = var.outbound_vnet_connectivity ? var.integration_subnet_id : null

  # auth settings
  auth_settings_v2 {
    auth_enabled             = true
    default_provider         = "azureactivedirectory"
    runtime_version          = "~1"
    require_authentication   = true
    unauthenticated_action   = "RedirectToLoginPage" #default: RedirectToLoginPage other:Return403
    require_https            = true
    forward_proxy_convention = "Standard"
    active_directory_v2 {
      client_id                  = var.auth_config.auth_client_id
      client_secret_setting_name = var.auth_config.auth_provider_secret
      tenant_auth_endpoint       = var.auth_config.auth_tenant_endpoint
      allowed_audiences = [
        "https://template-service-dev.planninginspectorate.gov.uk/.auth/login/aad/callback"
      ]
      allowed_applications = [
        var.auth_config.allowed_audiences
      ]
    }
    login {
      token_store_enabled            = true
      allowed_external_redirect_urls = []
    }
  }
}

resource "azurerm_linux_web_app_slot" "staging" {
  name           = "staging"
  app_service_id = azurerm_linux_web_app.web_app.id

  client_certificate_enabled = false
  https_only                 = true

  app_settings = local.app_settings

  identity {
    type = "SystemAssigned"
  }

  logs {
    detailed_error_messages = true
    failed_request_tracing  = true

    http_logs {
      file_system {
        retention_in_days = 4
        retention_in_mb   = 25
      }
    }
  }

  site_config {
    always_on                         = true
    http2_enabled                     = true
    health_check_path                 = var.health_check_path
    health_check_eviction_time_in_min = var.health_check_eviction_time_in_min

    application_stack {
      docker_image_name        = "${var.image_name}:main"
      docker_registry_url      = "https://${data.azurerm_container_registry.acr.login_server}"
      docker_registry_password = sensitive(data.azurerm_container_registry.acr.admin_password)
      docker_registry_username = data.azurerm_container_registry.acr.admin_username
    }

    ip_restriction_default_action = var.front_door_restriction ? "Deny" : "Allow"
    dynamic "ip_restriction" {
      for_each = var.front_door_restriction ? [1] : []

      content {
        name        = "FrontDoorInbound"
        service_tag = "AzureFrontDoor.Backend"
        action      = "Allow"
        priority    = 100
      }
    }
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      site_config["application_stack"],
      # ignore any changes to "hidden-link" and other tags
      # see https://github.com/hashicorp/terraform-provider-azurerm/issues/16569
      tags
    ]
  }

  virtual_network_subnet_id = var.outbound_vnet_connectivity ? var.integration_subnet_id : null

  # auth settings
  auth_settings_v2 {
    auth_enabled             = true
    default_provider         = "azureactivedirectory"
    runtime_version          = "~1"
    require_authentication   = true
    unauthenticated_action   = "RedirectToLoginPage" #default: RedirectToLoginPage other:Return403
    require_https            = true
    forward_proxy_convention = "Standard"
    active_directory_v2 {
      client_id                  = var.auth_config.auth_client_id
      client_secret_setting_name = var.auth_config.auth_provider_secret
      tenant_auth_endpoint       = var.auth_config.auth_tenant_endpoint
      allowed_audiences = [
        "https://template-service-dev.planninginspectorate.gov.uk/.auth/login/aad/callback"
      ]
      allowed_applications = [
        var.auth_config.allowed_audiences
      ]
    }
    login {
      token_store_enabled            = true
      allowed_external_redirect_urls = []
    }
  }
}

# TODO: I think this is redundant, Front Door does SSL termination for our DNS names and then routs requests to https://*.azurewebsites.net
resource "azurerm_app_service_certificate" "custom_hostname" {
  count = var.custom_hostname != null ? 1 : 0

  name                = var.custom_hostname
  resource_group_name = var.app_service_plan_resource_group_name
  location            = var.location
  key_vault_secret_id = var.custom_hostname_certificate_secret_id

  tags = var.tags
}

resource "azurerm_app_service_custom_hostname_binding" "custom_hostname" {
  count = var.custom_hostname != null ? 1 : 0

  hostname            = var.custom_hostname
  app_service_name    = azurerm_linux_web_app.web_app.name
  resource_group_name = var.resource_group_name
  ssl_state           = "SniEnabled"
  thumbprint          = azurerm_app_service_certificate.custom_hostname[0].thumbprint
}

resource "azurerm_private_endpoint" "private_endpoint" {
  count = var.inbound_vnet_connectivity ? 1 : 0

  name                = "pins-pe-${var.service_name}-${var.app_name}-${var.resource_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.endpoint_subnet_id

  private_dns_zone_group {
    name                 = "appserviceprivatednszone"
    private_dns_zone_ids = [var.app_service_private_dns_zone_id]
  }

  private_service_connection {
    name                           = "privateendpointconnection"
    private_connection_resource_id = azurerm_linux_web_app.web_app.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "private_endpoint_staging" {
  count = var.inbound_vnet_connectivity ? 1 : 0

  name                = "pins-pe-st-${var.service_name}-${var.app_name}-${var.resource_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.endpoint_subnet_id

  private_dns_zone_group {
    name                 = "appserviceprivatednszone-staging"
    private_dns_zone_ids = [var.app_service_private_dns_zone_id]
  }

  private_service_connection {
    name                           = "privateendpointconnection-staging"
    private_connection_resource_id = azurerm_linux_web_app.web_app.id
    subresource_names              = ["sites-staging"]
    is_manual_connection           = false
  }

  tags = var.tags
}

resource "azurerm_key_vault_access_policy" "read_secrets" {
  count = var.key_vault_id != null ? 1 : 0

  key_vault_id = var.key_vault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_linux_web_app.web_app.identity[0].principal_id

  certificate_permissions = []
  key_permissions         = []
  secret_permissions      = ["Get"]
  storage_permissions     = []
}

resource "azurerm_key_vault_access_policy" "read_secrets_staging_slot" {
  count = var.key_vault_id != null ? 1 : 0

  key_vault_id = var.key_vault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_linux_web_app_slot.staging.identity[0].principal_id

  certificate_permissions = []
  key_permissions         = []
  secret_permissions      = ["Get"]
  storage_permissions     = []
}
