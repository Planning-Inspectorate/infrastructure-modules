/**
* # azure-app-service-environment
* 
* This directory contains code that is used to deploy an App Service Environment.
*
* 
* ## How To Use
*
* ### Default Setup
*
* ```terraform
* module "ase" {
*   source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules/azure-app-service-environment"
*   environment = var.environment
*   application = var.application
*   location    = var.location
*   subnet_id   = module.subnet.subnet_id
*   tags        = var.tags
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
  name     = join("-", [var.environment, var.application, "ase", var.location])
  location = var.location
  tags     = local.tags
}


resource "azurerm_app_service_environment" "ase" {
  name                         = substr(join("-", [var.environment, var.application, "ase", var.location]), 0, 37)
  resource_group_name          = data.azurerm_resource_group.rg.name
  subnet_id                    = var.subnet_id
  pricing_tier                 = var.pricing_tier
  front_end_scale_factor       = var.front_end_scale_factor
  internal_load_balancing_mode = var.internal_load_balancing_mode
  allowed_user_ip_cidrs        = var.allowed_user_ip_cidrs
  tags                         = local.tags

  dynamic "cluster_setting" {
    for_each = var.cluster_setting
    content {
      name  = cluster_setting.key
      value = sensitive(cluster_setting.value)
    }
  }
}