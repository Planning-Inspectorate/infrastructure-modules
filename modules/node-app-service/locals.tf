locals {
  app_settings = merge(
    var.app_settings,
    {
      DOCKER_ENABLE_CI                = true
      DOCKER_REGISTRY_SERVER_PASSWORD = sensitive(local.secret_refs["docker-registry-server-password"])
      DOCKER_REGISTRY_SERVER_URL      = local.secret_refs["docker-registry-server-url"]
      DOCKER_REGISTRY_SERVER_USERNAME = local.secret_refs["docker-registry-server-username"]
    }
  )

  secrets_manual = [
    "docker-registry-server-password",
    "docker-registry-server-url",
    "docker-registry-server-username"
  ]

  secret_names = concat(local.secrets_manual, local.secrets_automated)

  secret_refs = {
    for name in local.secret_names : name => "@Microsoft.KeyVault(SecretUri=${var.key_vault_uri}secrets/${name}/)"
  }
}
