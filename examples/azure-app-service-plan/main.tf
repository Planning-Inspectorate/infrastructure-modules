/**
* # azure-app-service-plan
* 
* This directory contains code that will deploy an Azure App Service Plan which can be used for Web Apps, Function Apps and the Standard Logic App
* 
* ## How To Use
*
* ### Default Deployment
*
* ```terraform
* module "tempalte" {
*   source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-app-service-plan"
*   environment = "dev"
*   application = "app"
*   location    = "northeurope"
*   tags        = local.tags
* }
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
  name     = "${var.environment}-${var.application}-asp-${var.location}"
  location = var.location
  tags     = local.tags
}

resource "azurerm_app_service_plan" "asp" {
  name                         = "${var.environment}-${var.application}-asp-${var.location}"
  location                     = var.location
  resource_group_name          = data.azurerm_resource_group.rg.name
  kind                         = var.kind
  maximum_elastic_worker_count = var.elastic_worker_count
  reserved                     = var.reserved
  sku {
    tier     = var.sku["tier"]
    size     = var.sku["size"]
    capacity = var.sku["capacity"]
  }
  app_service_environment_id = var.app_service_env_id
  per_site_scaling           = var.site_scaling
  tags                       = local.tags
}
