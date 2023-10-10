resource "azurerm_key_vault_secret" "app_secret" {
  #checkov:skip=CKV_AZURE_41: TODO: Secret rotation
  #checkov:skip=CKV_AZURE_114: No need to set content type via Terraform, as secrets to be updated in Portal
  for_each = toset(module.app_services.secrets_manual)

  key_vault_id = var.key_vault_id
  name         = each.value
  value        = "<enter_value>"

  tags = local.tags

  lifecycle {
    ignore_changes = [
      value,
      version
    ]
  }
}

resource "time_offset" "secret_expire_date" {
  offset_years = 5
}

resource "azurerm_key_vault_secret" "docker_registry_server_password" {
  name            = "docker-registry-server-password"
  value           = data.azurerm_container_registry.acr.admin_password
  key_vault_id    = var.key_vault_id
  content_type    = "text/plain"
  expiration_date = time_offset.secret_expire_date.rfc3339

  tags = local.tags
}
