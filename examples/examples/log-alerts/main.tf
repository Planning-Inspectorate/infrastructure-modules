/**
* # log-alerts
* 
* An exmaple of applying the log alerts baseline to a log analytics workspace
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
  name     = "${var.environment}-${var.application}-log-alerts-${var.location}"
  location = var.location
  tags     = local.tags
}

resource "azurerm_monitor_action_group" "action_group" {
  name                = "example-action-group"
  resource_group_name = azurerm_resource_group.resource_group.name
  short_name          = "p0action"

  email_receiver {
    name                    = "example"
    email_address           = "PlatformServices@Hiscox.onmicrosoft.com"
    use_common_alert_schema = true
  }
}

module "law" {
  source              = "../../azure-log-analytics"
  resource_group_name = azurerm_resource_group.resource_group.name
  environment         = var.environment
  application         = var.application
  location            = var.location
  tags                = local.tags
}

module "log_alerts" {
  source              = "../../azure-monitor-log-alerts"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  action_group_id     = azurerm_monitor_action_group.action_group.id
  workspace_id        = module.law.workspace_id
}