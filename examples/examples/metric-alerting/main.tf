/**
* # metric-alerting
* 
* An example of deploying a storage account and enablaing an alert.
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
  name     = "${var.environment}-${var.application}-examplemetric-${var.location}"
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

module "alert_storage" {
  source                = "../../azure-monitor-metrics"
  target_resource_group = module.storage.resource_group_name
  target_resource_name  = module.storage.storage_name
  target_resource_id    = module.storage.storage_id
  target_resource_type  = "Microsoft.Storage/storageAccounts"
  action_group_id       = data.azurerm_monitor_action_group.ag.id
  tags                  = local.tags
}
