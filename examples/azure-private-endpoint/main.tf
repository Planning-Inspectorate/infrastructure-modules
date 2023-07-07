/**
* # azure-private-endpoint
* 
* This directory contains code that is used to create a private endpoint to connect a supported resource type
* to a subnet in an Azure virtual network for private conenctivity.
* It is designed to support the following standards and conventions
*
* * Terraform configuration files (e.g. data.tf for terraform data elements, output.tf for output variables). Note that this template cannot cater for every kind of resource that may be described by Terraform. There is obviously some discretion on the part of the engineer to use meaningful names for these files.
* * Use of terratest on build agent to run CI tests for the module
* * Local terraform deployments with native terraform commands and authentication to azure using az login (i.e. as yourself, which makes sense)
* * Use of terraform-docs as standard
* 
* ## How To Use
* 
* Example code snippet (endpoint for a blob storage account):
*
* ```terraform
* module "private_endpoint" {
*   source                              = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-private-endpoint"
*   environment                         = "dev"
*   application                         = "my-own-private-endpoint"
*   location                            = "northeurope"
*   private_dns_zone_id                 = data.azurerm_private_dns_zone.zone.id
*   private_connection_resource_id      = "/subscriptions/bab9ed05-2c6e-4631-a0cf-7373c33838cc/resourceGroups/ci-splunkdeploy-vm-westeurope/providers/Microsoft.Storage/storageAccounts/0zbyo2rw4vto7ihcq4z70rf9"
*   subresource_names                   = ["blob"]
*   subnet_name                         = "sandbox"
*   virtual_network_name                = "subscription-vnet-northeurope"
*   virtual_network_resource_group_name = "subscription-vnet-northeurope"
* }
* ```
* See the Microsoft doc at https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-overview#private-link-resource for more information about the allowed subresource names.
* See wiki page for more information: https://hiscox.atlassian.net/wiki/spaces/TPC/pages/646709562
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
  name     = join("-", [var.environment, var.application, "pe", var.location])
  location = var.location
  tags     = local.tags
}

resource "azurerm_private_endpoint" "pe" {
  name                = join("-", [var.environment, var.application, var.label, "pe", var.location])
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = data.azurerm_subnet.subnet.id

  private_dns_zone_group {
    name                 = join("-", [var.environment, var.application, "pdzg", var.location])
    private_dns_zone_ids = [var.private_dns_zone_id]
  }

  private_service_connection {
    name                           = join("-", [var.environment, var.application, "pe", var.location])
    private_connection_resource_id = var.private_connection_resource_id
    is_manual_connection           = false
    subresource_names              = var.subresource_names
  }

  tags = local.tags
}
