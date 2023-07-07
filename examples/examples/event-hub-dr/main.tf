/**
* # event-hub-dr
* 
* An example of deploying a pair of event hubs in a DR setup
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

resource "azurerm_resource_group" "primary" {
  name     = join("-", [var.environment, var.application, "eventhub", var.location])
  location = var.location
  tags     = local.tags
}

resource "azurerm_resource_group" "secondary" {
  name     = join("-", [var.environment, var.application, "eventhub", var.location_dr])
  location = var.location_dr
  tags     = local.tags
}

module "storage" {
  source                 = "../../azure-storage-account"
  environment            = var.environment
  application            = var.application
  location               = var.location
  resource_group_name    = azurerm_resource_group.primary.name
  network_default_action = "Allow" // don't set this for real, this just makes local testing simple
  container_name         = ["container"]
  tags                   = local.tags
}

module "primary" {
  source              = "../../azure-event-hub"
  resource_group_name = azurerm_resource_group.primary.name
  environment         = var.environment
  application         = var.application
  location            = var.location
  tags                = var.tags
  event_hubs          = var.event_hubs
  capture_description = {
    enabled             = "true"
    encoding            = "Avro"
    interval_in_seconds = "300"
    size_limit_in_bytes = "314572800"
    skip_empty_archives = "false"
    archive_name_format = "{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}"
    blob_container_name = "container"
    storage_account_id  = module.storage.storage_id
  }
}

module "secondary" {
  source              = "../../azure-event-hub"
  resource_group_name = azurerm_resource_group.secondary.name
  environment         = var.environment
  application         = var.application
  location            = var.location_dr
  tags                = var.tags
}

resource "azurerm_eventhub_namespace_disaster_recovery_config" "dr" {
  name                 = substr(join("-", [module.primary.namespace_name, module.secondary.namespace_name]), 0, 50)
  resource_group_name  = module.primary.resource_group_name
  namespace_name       = module.primary.namespace_name
  partner_namespace_id = module.secondary.namespace_id

  depends_on = [
    module.primary,
    module.secondary
  ]
}
