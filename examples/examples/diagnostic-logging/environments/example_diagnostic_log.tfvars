/*
    Terraform configuration file defining variable value for this environment
*/
environment = "ci"

application = "diagnostics"

location = "northeurope"

log_analytics_resource_group = "devtest-itspsg-subscription-northeurope"

log_analytics_name = "devtest-its-logworkspace-northeurope"

sql_server_ads_email_notifications = [
  "pedro@hiscox.com"
]

allow_subnet_ids = {
  bamboo = "/subscriptions/bab9ed05-2c6e-4631-a0cf-7373c33838cc/resourceGroups/ExpressRoute-RG-TC1-01/providers/Microsoft.Network/virtualNetworks/Core-VN-01/subnets/bam-sn-01"
  ado_agent = "/subscriptions/c3dbe116-7ab5-4155-89c0-a81dcd9bfe9e/resourceGroups/production-its-subscription-northeurope/providers/Microsoft.Network/virtualNetworks/production-its-vnet-northeurope/subnets/production-itsaks-aks"
}

elastic_pool_sku = {
  name     = "BC_Gen5"
  tier     = "BusinessCritical"
  family   = "Gen5"
  capacity = 4
}

elastic_pool_capacity = 6

pool_dbs = {
  staging = {
    max_size_gb = 64
  },
  sample = {
    max_size_gb = 32
  },
}

ad_sql_service_account = "" # Unset, so default DBA group added as AAD admins
#ad_sql_service_account = "svc_ci_exsql_tfsql@hiscox.com"

key_vault_name           = "devtestitskvne"

key_vault_rg             = "devtest-itspsg-subscription-northeurope"