/*
    Terraform configuration file defining provider configuration
*/
locals {
  tags = merge(var.tags,
    tomap({
      application = var.application,
      environment = var.environment,
      repo        = "https://dev.azure.com/hiscox/gp-psg/_git/terraform-modules",
      created     = time_static.t.rfc3339
    }),
    var.tags,
  )

  # Prepare variables defining cicd subnets for use in storage/sql firewall rules
  # Full list of cicd subnets with regions - we need this because we need to take decisions on region
  cicd_subnet_ids_with_regions = {
    northeurope = [
      "/subscriptions/bab9ed05-2c6e-4631-a0cf-7373c33838cc/resourceGroups/ExpressRoute-RG-TC1-01/providers/Microsoft.Network/virtualNetworks/Core-VN-01/subnets/bam-sn-01",
      "/subscriptions/bab9ed05-2c6e-4631-a0cf-7373c33838cc/resourceGroups/ExpressRoute-RG-TC1-01/providers/Microsoft.Network/virtualNetworks/Core-VN-01/subnets/vm-sn-01",
      "/subscriptions/c3dbe116-7ab5-4155-89c0-a81dcd9bfe9e/resourceGroups/production-its-subscription-northeurope/providers/Microsoft.Network/virtualNetworks/production-its-vnet-northeurope/subnets/production-itsaks-aks",
      "/subscriptions/bab9ed05-2c6e-4631-a0cf-7373c33838cc/resourceGroups/ExpressRoute-RG-TC1-01/providers/Microsoft.Network/virtualNetworks/Core-VN-01/subnets/prod-platform-aks-node-pool"
    ],
    westeurope = [
      "/subscriptions/c3dbe116-7ab5-4155-89c0-a81dcd9bfe9e/resourceGroups/production-its-subscription-westeurope/providers/Microsoft.Network/virtualNetworks/production-its-vnet-westeurope/subnets/production-itsaks-aks",
      "/subscriptions/bab9ed05-2c6e-4631-a0cf-7373c33838cc/resourceGroups/ExpressRoute-RG-TC2-01/providers/Microsoft.Network/virtualNetworks/Core-VN-01/subnets/prod-platform-aks-node-pool"
    ]
  }
  # All cicd subnets as a list
  cicd_subnet_ids = flatten([for k, v in local.cicd_subnet_ids_with_regions : v])
  # All cicd subnets in a particular region, as a list
  cicd_subnet_ids_in_this_region = flatten([for k, v in local.cicd_subnet_ids_with_regions : v if k == var.location])

  administrator_login_name = "${var.environment}${var.application}_sqladmin"

  # Builds active directory service account name that will be used as initial SQL System Administrator
  ad_sql_service_account = "svc_${var.environment_code}_${var.application}@hiscox.com"

  standalone_dbs_defaults = {
    auto_pause_delay_in_minutes = null
    min_capacity                = null
  }

  standalone_dbs = { for key, value in var.standalone_dbs : key => (merge(local.standalone_dbs_defaults, value)) }

  Gb = 1024 * 1024 * 1024
  sku_with_capacity = merge(
    var.elastic_pool_sku,
    {
      "capacity" = var.elastic_pool_capacity
    },
  )

  # Build the local value for the SQL admin password - if not provided will use the one generated.
  sql_server_admin_password = var.sql_server_admin_password == "" ? sensitive(random_password.sql_admin_password.result) : sensitive(var.sql_server_admin_password)

  default_database_user = {
    database_name          = ""
    database_user          = ""
    object_id              = null
    database_user_password = null
    database_user_role     = [] 
  }

  database_users = {for u in var.database_users : "${u.database_name}-${u.database_user}" => merge(local.default_database_user, u) }

  default_ads_email_notifications = ["vulnerabilitymanagment@hiscox.com"]

  sql_server_ads_email_notifications = concat(local.default_ads_email_notifications, var.sql_server_ads_email_notifications)

  storage_soft_delete_retention_policy = var.storage_soft_delete_retention_policy == true || substr(var.environment, 0, 2) == "pr" ? true : var.storage_soft_delete_retention_policy
}
