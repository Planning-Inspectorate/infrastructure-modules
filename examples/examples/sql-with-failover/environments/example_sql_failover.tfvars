/*
    Terraform configuration file defining variable value for this environment
*/
environment = "ci"

location = "northeurope"

application = "exsql"

sql_server_ads_email_notifications = [
  "pedro@hiscox.com"
]

allow_subnet_ids = {}

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

ad_sql_service_account = "svc_ci_exsql_tfsql@hiscox.com"

key_vault_name = "devtestitskvne"
key_vault_rg   = "devtest-itspsg-subscription-northeurope"

//ad_sql_service_account_password = ""