/**
* # azure-application-insights
* 
* This directory contains code that is used to deploy an Application Insights instance.
* 
* ## How To Use
*
* ### Insights with workspace integration
*
* ```terraform
* module "ai" {
*   source           = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-application-insights"
*   environment      = "dev"
*   application      = "app"
*   location         = "northeurope"
*   application_type = "web"
*   workspace_id     = var.workspace_id
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
  name     = "${var.environment}-${var.application}-ai-${var.location}"
  location = var.location
  tags     = local.tags
}

resource "azurerm_application_insights" "ai" {
  name                                  = "${var.environment}-${var.application}-app-insights-${var.location}"
  location                              = var.location
  resource_group_name                   = data.azurerm_resource_group.rg.name
  application_type                      = var.application_type
  daily_data_cap_in_gb                  = var.daily_data_cap_in_gb
  daily_data_cap_notifications_disabled = var.daily_data_cap_notifications_disabled
  retention_in_days                     = var.retention_in_days
  sampling_percentage                   = var.sampling_percentage
  disable_ip_masking                    = var.disable_ip_masking
  workspace_id                          = var.workspace_id
  tags                                  = local.tags
}