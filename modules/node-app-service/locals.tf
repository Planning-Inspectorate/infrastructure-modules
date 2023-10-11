locals {
  app_settings = merge(
    var.app_settings,
    {
      DOCKER_ENABLE_CI                = true
      DOCKER_REGISTRY_SERVER_PASSWORD = sensitive(local.secret_refs["docker-registry-server-password"])
      DOCKER_REGISTRY_SERVER_URL      = data.azurerm_container_registry.acr.login_server
      DOCKER_REGISTRY_SERVER_USERNAME = data.azurerm_container_registry.acr.admin_username
    }
  )

  secrets_manual = [
    var.secrets_manual
  ]
  secrets_automated = [
    "docker-registry-server-password"
  ]

  secret_names = concat(local.secrets_manual, local.secrets_automated)

  secret_refs = {
    for name in local.secret_names : name => "@Microsoft.KeyVault(SecretUri=${var.key_vault_uri}secrets/${name}/)"
  }

  tags = var.tags
}
