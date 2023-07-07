/*
    Terraform configuration file defining provider configuration
*/
locals {
  tags = merge(
    tomap({
      application = var.application,
      environment = var.environment,
      repo        = "https://dev.azure.com/hiscox/gp-psg/_git/terraform-modules",
      created     = time_static.t.rfc3339
    }),
    var.tags,
  )

  environment_codes = {
    "prod"           = "pr"
    "production"     = "pr"
    "dev"            = "dv"
    "devtest"        = "dt"
    "systest"        = "sy"
    "uat"            = "ut"
    "staging"        = "st"
    "training"       = "tr"
    "livesupport"    = "ls"
    "sharedservices" = "ss"
    "poc"            = "pc"
    "ci"             = "ci"
  }

  location_codes = {
    "northeurope" = "ne"
    "westeurope"  = "we"
    "ukwest"      = "uk"
  }

  cicd_subnet_ids = [
    "/subscriptions/bab9ed05-2c6e-4631-a0cf-7373c33838cc/resourceGroups/ExpressRoute-RG-TC1-01/providers/Microsoft.Network/virtualNetworks/Core-VN-01/subnets/bam-sn-01",
    "/subscriptions/bab9ed05-2c6e-4631-a0cf-7373c33838cc/resourceGroups/ExpressRoute-RG-TC1-01/providers/Microsoft.Network/virtualNetworks/Core-VN-01/subnets/vm-sn-01",
    "/subscriptions/c3dbe116-7ab5-4155-89c0-a81dcd9bfe9e/resourceGroups/production-its-subscription-northeurope/providers/Microsoft.Network/virtualNetworks/production-its-vnet-northeurope/subnets/production-itsaks-aks",
    "/subscriptions/c3dbe116-7ab5-4155-89c0-a81dcd9bfe9e/resourceGroups/production-its-subscription-westeurope/providers/Microsoft.Network/virtualNetworks/production-its-vnet-westeurope/subnets/production-itsaks-aks",
    "/subscriptions/bab9ed05-2c6e-4631-a0cf-7373c33838cc/resourceGroups/ExpressRoute-RG-TC1-01/providers/Microsoft.Network/virtualNetworks/Core-VN-01/subnets/prod-platform-aks-node-pool",
    "/subscriptions/bab9ed05-2c6e-4631-a0cf-7373c33838cc/resourceGroups/ExpressRoute-RG-TC2-01/providers/Microsoft.Network/virtualNetworks/Core-VN-01/subnets/prod-platform-aks-node-pool"
  ]

  access_policies = [
    for p in var.access_policies : merge({
      group_names             = []
      object_ids              = []
      user_principal_names    = []
      certificate_permissions = []
      key_permissions         = []
      secret_permissions      = []
      storage_permissions     = []
    }, p)
  ]

  group_names          = distinct(flatten(local.access_policies[*].group_names))
  user_principal_names = distinct(flatten(local.access_policies[*].user_principal_names))

  group_object_ids = { for g in data.azuread_group.groups : lower(g.display_name) => g.id }
  user_object_ids  = { for u in data.azuread_user.users : lower(u.user_principal_name) => u.id }

  flattened_access_policies = concat(
    flatten([
      for p in local.access_policies : flatten([
        for i in p.object_ids : {
          object_id               = i
          certificate_permissions = p.certificate_permissions
          key_permissions         = p.key_permissions
          secret_permissions      = p.secret_permissions
          storage_permissions     = p.storage_permissions
        }
      ])
    ]),
    flatten([
      for p in local.access_policies : flatten([
        for n in p.group_names : {
          object_id               = local.group_object_ids[lower(n)]
          certificate_permissions = p.certificate_permissions
          key_permissions         = p.key_permissions
          secret_permissions      = p.secret_permissions
          storage_permissions     = p.storage_permissions
        }
      ])
    ]),
    flatten([
      for p in local.access_policies : flatten([
        for n in p.user_principal_names : {
          object_id               = local.user_object_ids[lower(n)]
          certificate_permissions = p.certificate_permissions
          key_permissions         = p.key_permissions
          secret_permissions      = p.secret_permissions
          storage_permissions     = p.storage_permissions
        }
      ])
    ])
  )

  grouped_access_policies = { for p in local.flattened_access_policies : p.object_id => p... }

  combined_access_policies = [
    for k, v in local.grouped_access_policies : {
      tenant_id               = data.azurerm_client_config.current.tenant_id
      object_id               = k
      application_id          = null
      certificate_permissions = distinct(flatten(v[*].certificate_permissions))
      key_permissions         = distinct(flatten(v[*].key_permissions))
      secret_permissions      = distinct(flatten(v[*].secret_permissions))
      storage_permissions     = distinct(flatten(v[*].storage_permissions))
    }
  ]

  self_permissions = [
    {
      tenant_id               = data.azurerm_client_config.current.tenant_id
      object_id               = data.azurerm_client_config.current.object_id
      application_id          = null
      key_permissions         = ["create", "delete", "get", "list", "purge"]
      secret_permissions      = ["delete", "get", "list", "purge", "set"]
      certificate_permissions = ["create", "delete", "deleteissuers", "get", "getissuers", "list", "listissuers", "managecontacts", "manageissuers", "purge", "setissuers", "update"]
      storage_permissions     = ["get", "delete", "list", "purge", "set"]
    }
  ]
  
  purge_protection_enabled = var.purge_protection_enabled == "true" || substr(var.environment, 0, 2) == "pr" ? true : var.purge_protection_enabled

}