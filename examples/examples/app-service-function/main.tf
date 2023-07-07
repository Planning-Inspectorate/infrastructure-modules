/**
* # app-service-function
* 
* This example provisions a storage-account which is consumed by an Azure Function App derived from the azure-app-service module.
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
  name     = "${var.environment}-${var.application}-examplefunc-${var.location}"
  location = var.location
  tags     = local.tags
}

module "storage" {
  // source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-storage-account"
  source                 = "../../azure-storage-account"
  environment            = var.environment
  application            = var.application
  location               = var.location
  resource_group_name    = azurerm_resource_group.resource_group.name
  network_default_action = "Allow" // don't set this for real, this just makes local testing simple
  network_rule_bypass    = ["AzureServices", "Logging", "Metrics"]
}

module "asp" {
  source              = "../../azure-app-service-plan"
  resource_group_name = azurerm_resource_group.resource_group.name
  environment         = var.environment
  application         = var.application
  location            = var.location
  tags                = local.tags
}

module "func" {
  // source                     = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-app-service"
  source                     = "../../azure-app-service-function"
  app_service_plan_id        = module.asp.id
  environment                = var.environment
  application                = var.application
  location                   = var.location
  storage_account_name       = module.storage.storage_name
  storage_account_access_key = module.storage.primary_access_key
  resource_group_name        = azurerm_resource_group.resource_group.name
  site_config = {
    linux_fx_version = "PYTHON|3.9"
  }
  function_version = "~3"
  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "python"
  }
}