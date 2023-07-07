/**
* # azure-logic-app
*
* Provisions a Logic App.
* 
* ## How To Use
*
* * Provide inputs by calling this as a sub-module and you're set
* * If only the LogicApp resource is going to be built, omit optional parameter blocks
*
* ```HCL
* module "azure_logic_app" {
*   source            = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-logic-app"
*   environment       = var.environment
*   application       = var.application
*   location          = var.location
*   tags              = var.tags
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
  name     = "${var.environment}-${var.application}-logic-app-${var.location}"
  location = var.location
  tags     = local.tags
}
resource "azurerm_logic_app_workflow" "logicapp" {
  name                               = "${var.environment}-${var.application}-la-${var.location}"
  location                           = var.location
  resource_group_name                = data.azurerm_resource_group.rg.name
  integration_service_environment_id = var.integration_service_environment_id
  logic_app_integration_account_id   = var.logic_app_integration_account_id
  workflow_parameters                = var.workflow_parameters
  parameters                         = var.parameters
  workflow_schema                    = var.workflow_schema
  tags                               = local.tags
}
