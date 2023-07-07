/**
* # azure-network-watcher-flow-log
* 
* CI for NSG Flow Log
* 
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

resource "azurerm_resource_group" "resource_group" {
  name     = "${var.environment}-${var.application}-netflow-${var.location}"
  location = var.location
  tags     = var.tags
}

module "nsg" {
  source              = "../../azure-network-security-group"
  environment         = var.environment
  application         = var.application
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  nsg_in_rules        = var.nsg_in_rules
  nsg_out_rules       = var.nsg_out_rules
  tags                = var.tags
}

module "storage" {
  source              = "../../azure-storage-account"
  resource_group_name = azurerm_resource_group.resource_group.name
  environment         = var.environment
  application         = var.application
  location            = var.location
  network_rule_bypass = ["AzureServices"]
  tags                = var.tags
}

module "law" {
  source              = "../../azure-log-analytics"
  resource_group_name = azurerm_resource_group.resource_group.name
  environment         = var.environment
  application         = var.application
  location            = var.location
  tags                = var.tags
}

module "flow_log" {
  source                                      = "../../azure-network-watcher-flow-log"
  environment                                 = var.environment
  application                                 = var.application
  location                                    = var.location
  tags                                        = var.tags
  flow_log_name                               = join("-", [var.environment, var.application, "flow-log"])
  network_watcher_name                        = var.network_watcher_name
  network_watcher_resource_group_name         = var.network_watcher_resource_group_name
  log_analytics_workspace_resource_group_name = module.law.resource_group_name
  log_analytics_workspace_name                = module.law.workspace_name
  network_security_group_id                   = module.nsg.network_security_group_id
  storage_account_id                          = module.storage.storage_id

  depends_on = [
    module.law
  ]
}
