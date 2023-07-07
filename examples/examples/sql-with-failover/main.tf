/**
* # sql-with-failover
* 
* Example provisioning two PaaS SQL instances configured as a failover group
* 
* ## How To Update this README.md
*
* terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*
* ## Diagrams
*
* ![image info](./diagrams/design.png)
*
* Unfortunately a number of tools that can parse Terraform code/statefiles and generate architetcure diagrams are limited and most are in their infancy. The built in `terraform graph` is only really useful for looking at dependencies and is too verbose to be considered a diagram on an environment.
*
* We can however turn this on its head and look at using deployed resources to produce a diagram as a stop gap. AzViz is a tool which takes one or more resource groups as input and it will parse their contents and produce a more architecture-like diagram. It will also work out the relation between different resources. Check out all its features [here](https://github.com/PrateekKumarSingh/AzViz). To use it to store a diagram post deployment:
*
* ```pwsh
* Connect-AzAccount
* Set-AzContext -Subscription 'xxxx-xxxx'
* Export-AzViz -ResourceGroup my-resource-group-1, my-rg-2 -Theme light -OutputFormat png -OutputFilePath 'diagrams/design.png' -CategoryDepth 1 -LabelVerbosity 2
* ```
*/

resource "azurerm_resource_group" "rg_primary" {
  name     = "${var.environment}-${var.application}-sql-northeurope"
  location = "northeurope"
  tags     = local.tags
}

resource "azurerm_resource_group" "rg_secondary" {
  name     = "${var.environment}-${var.application}-sql-westeurope"
  location = "westeurope"
  tags     = local.tags
}

module "sql_primary" {
  source                             = "../../azure-sql"
  environment                        = var.environment
  application                        = var.application
  resource_group_name                = azurerm_resource_group.rg_primary.name
  location                           = "northeurope"
  allow_subnet_ids                   = var.allow_subnet_ids
  elastic_pool_capacity              = var.elastic_pool_capacity
  elastic_pool_sku                   = var.elastic_pool_sku
  pool_dbs                           = var.pool_dbs
  sql_server_ads_email_notifications = var.sql_server_ads_email_notifications
  ad_sql_service_account             = var.ad_sql_service_account
  ad_sql_service_account_password    = sensitive(data.azurerm_key_vault_secret.ad_sql_service_account_password.value)
}

module "sql_secondary" {
  source                             = "../../azure-sql"
  environment                        = var.environment
  application                        = var.application
  resource_group_name                = azurerm_resource_group.rg_secondary.name
  location                           = "westeurope"
  allow_subnet_ids                   = var.allow_subnet_ids
  elastic_pool_capacity              = var.elastic_pool_capacity
  elastic_pool_sku                   = var.elastic_pool_sku
  pool_dbs                           = var.pool_dbs
  sql_server_ads_email_notifications = var.sql_server_ads_email_notifications
  ad_sql_service_account             = var.ad_sql_service_account
  ad_sql_service_account_password    = sensitive(data.azurerm_key_vault_secret.ad_sql_service_account_password.value)
  is_secondary                       = true
  source_dbs                         = { for k, v in module.sql_primary.pool_db_data : k => v.id }
}

resource "azurerm_sql_failover_group" "sql_failover_group" {
  name                = "${var.environment}-${var.application}-failover-group"
  resource_group_name = azurerm_resource_group.rg_primary.name
  server_name         = module.sql_primary.sql_server_name
  databases           = [for k, v in module.sql_primary.pool_db_data : v.id]

  partner_servers {
    id = module.sql_secondary.sql_server_id
  }

  read_write_endpoint_failover_policy {
    mode          = var.sql_failovergroup_mode
    grace_minutes = var.sql_failovergroup_grace_minutes
  }

  depends_on = [
    module.sql_secondary
  ]
}
