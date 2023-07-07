locals {
  tenant_id = data.azurerm_client_config.current.tenant_id
  admin_certificate_permissions = [
    "create",
    "get",
    "list",
    "import",
    "update",
    "delete",
    "recover",
    "backup",
    "restore",
  ]

  admin_key_permissions = [
    "get",
    "list",
    "update",
    "create",
    "import",
    "delete",
    "recover",
    "backup",
    "restore",
  ]

  admin_secret_permissions = [
    "get",
    "list",
    "set",
    "delete",
    "recover",
    "backup",
    "restore",
  ]

  write_certificate_permissions = [
    "create",
    "get",
    "list",
    "import",
    "update",
    "delete",
  ]

  write_key_permissions = [
    "create",
    "get",
    "list",
    "import",
    "update",
    "delete",
  ]

  write_secret_permissions = [
    "get",
    "list",
    "set",
    "delete",
  ]

  read_certificate_permissions = [
    "get",
    "list",
  ]

  read_key_permissions = [
    "get",
    "list",
  ]

  read_secret_permissions = [
    "get",
    "list",
  ]
}
