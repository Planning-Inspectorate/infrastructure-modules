locals {
  app_settings = merge(
    var.app_settings,
    {
      DOCKER_ENABLE_CI         = true
      docker_registry_password = sensitive(data.azurerm_container_registry.acr.admin_password)
      docker_registry_url      = data.azurerm_container_registry.acr.login_server
      docker_registry_username = data.azurerm_container_registry.acr.admin_username
    }
  )
}
