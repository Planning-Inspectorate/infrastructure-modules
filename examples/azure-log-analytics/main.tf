/**
* # azure-log-analytics
* 
* This directory stands up an Azure Log Analytics Workspace
* 
* ## How To Use
* 
* ```terraform
* module "law" {
*   source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-log-analytics"
*   environment = "dev"
*   application = "app"
*   location    = "northeurope"
*  }
* ```
* 
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

// if you do not specify an existing resurce group one will be created for you,
// when supplying the resource group name to a resource declaration you should use
// the data type i.e 'data.azurerm_resource_group.rg.name'
resource "azurerm_resource_group" "rg" {
  count    = var.resource_group_name == "" ? 1 : 0
  name     = "${var.environment}-${var.application}-law-${var.location}"
  location = var.location
  tags     = local.tags
}

resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = "${var.environment}-${var.application}-logworkspace-${var.location}"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku                 = var.log_analytics_sku
  retention_in_days   = var.retention_days
  tags                = local.tags
}

resource "azurerm_log_analytics_data_export_rule" "export" {
  for_each                = var.export_rules
  name                    = each.key
  resource_group_name     = data.azurerm_resource_group.rg.name
  workspace_resource_id   = azurerm_log_analytics_workspace.log_analytics.id
  destination_resource_id = each.value.dest_resource_id
  table_names             = each.value.tables
  enabled                 = each.value.enabled
}
