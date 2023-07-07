/**
* # azure-logic-app-standard
*
* CI for a Logic App Standard.
*
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

resource "azurerm_resource_group" "resource_group" {
  name     = "${var.environment}-${var.application}-testci-${var.location}"
  location = var.location
  tags     = var.tags
}

module "storage" {
  source                 = "../../azure-storage-account"
  environment            = var.environment
  application            = var.application
  location               = var.location
  resource_group_name    = azurerm_resource_group.resource_group.name
  network_default_action = "Allow" // don't set this for real, this just makes local testing simple
  tags                   = var.tags
}

module "asp" {
  source               = "../../azure-app-service-plan"
  environment          = var.environment
  application          = var.application
  location             = var.location
  resource_group_name  = azurerm_resource_group.resource_group.name
  kind                 = "elastic"
  reserved             = false
  elastic_worker_count = 20
  sku = {
    tier     = "WorkflowStandard"
    size     = "WS1"
    capacity = "1"
  }
  tags = var.tags
}

module "las" {
  source                     = "../../azure-logic-app-standard"
  environment                = var.environment
  application                = var.application
  resource_group_name        = azurerm_resource_group.resource_group.name
  location                   = var.location
  app_service_plan_id        = module.asp.id
  storage_account_name       = module.storage.storage_name
  storage_account_access_key = module.storage.primary_access_key

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME"     = "node"
    "WEBSITE_NODE_DEFAULT_VERSION" = "~12"
  }
  tags = var.tags
}