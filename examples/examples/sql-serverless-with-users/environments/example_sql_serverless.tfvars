/*
    Terraform configuration file defining variable value for this environment
*/
environment = "ci"

location = "northeurope"

application = "exsqlserverless"

allow_subnet_ids = {}

standalone_dbs = {
    serverless = {
      max_size_gb                 = 6
      collation                   = "Latin1_General_CS_AI"
      sku_name                    = "GP_S_Gen5_1"
      min_capacity                = 1
      auto_pause_delay_in_minutes = -1
    },
    serverlessdelay = {
      max_size_gb                 = 6
      collation                   = "Latin1_General_CS_AI"
      sku_name                    = "GP_S_Gen5_1"
      min_capacity                = 1
      auto_pause_delay_in_minutes = 60
    },
}

database_users = [
    {
      database_name          = "serverlessdelay"
      database_user          = "svc_ci_exsql_tfsql@hiscox.com"
      object_id              = "f8755824-86e5-42f2-9817-8d7a618127f3"
      database_user_role     = "db_datareader"
    },
]