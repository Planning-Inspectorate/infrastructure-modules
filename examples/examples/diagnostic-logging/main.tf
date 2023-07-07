/**
* # diagnostic-logging
* 
* An example of deploying a storage account with SQL PaaS and enabling diagnostic logging to a Log Analytics Workspace.
* 
* ## How To Update this README.md
*
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
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

resource "azurerm_resource_group" "resource_group" {
  name     = "${var.environment}-${var.application}-examplediag-${var.location}"
  location = var.location
  tags     = local.tags
}

module "storage" {
  source                 = "../../azure-storage-account"
  environment            = var.environment
  application            = var.application
  location               = var.location
  resource_group_name    = azurerm_resource_group.resource_group.name
  network_default_action = "Allow" // don't set this for real, this just makes local testing simple
  tags                   = local.tags
}

module "sql" {
  source                             = "../../azure-sql"
  environment                        = var.environment
  application                        = var.application
  resource_group_name                = azurerm_resource_group.resource_group.name
  location                           = var.location
  allow_subnet_ids                   = var.allow_subnet_ids
  elastic_pool_capacity              = var.elastic_pool_capacity
  elastic_pool_sku                   = var.elastic_pool_sku
  pool_dbs                           = var.pool_dbs
  sql_server_ads_email_notifications = var.sql_server_ads_email_notifications
  ad_sql_service_account             = var.ad_sql_service_account
  ad_sql_service_account_password    = sensitive(data.azurerm_key_vault_secret.ad_sql_service_account_password.value)
  tags                               = local.tags
}

module "diagnostics_storage" {
  source                     = "../../azure-monitor-logging"
  target_resource_id         = module.storage.storage_id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.law.id
}

module "diagnostics_sql_db" {
  count                      = length(keys(var.pool_dbs))
  source                     = "../../azure-monitor-logging"
  target_resource_id         = module.sql.pool_db_ids[count.index]
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.law.id
}