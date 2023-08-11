locals {
  app_settings = merge(
    var.app_settings,
    {
      DOCKER_ENABLE_CI                = true
      DOCKER_REGISTRY_SERVER_PASSWORD = sensitive(data.azurerm_container_registry.acr.admin_password)
      DOCKER_REGISTRY_SERVER_URL      = data.azurerm_container_registry.acr.login_server
      DOCKER_REGISTRY_SERVER_USERNAME = data.azurerm_container_registry.acr.admin_username
    }
  )
}
