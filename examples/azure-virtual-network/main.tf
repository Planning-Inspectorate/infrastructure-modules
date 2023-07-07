/**
* # azure-virtual-network
* 
* This directory contains code that is used to deploy an Azure Virtual Network with a Ddos protection plan
* 
* ## How To Use
* 
* Include example code snippets:
*
* ### Example One
*
* ```terraform
* module "vnet" {
*   source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-virtual-network"
*   environment = "dev"
*   application = "app"
*   location    = "northeurope"
*   address_space = ["192.168.0.0/16"]
* }
* ```
* 
* 1. Create a new module directory
* 1. Use the contents of this module as a base for all files in your new module
* 
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
  name     = "${var.environment}-${var.application}-vnet-${var.location}"
  location = var.location
  tags     = local.tags
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.environment}-${var.application}-vnet-${var.location}"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = var.address_space
  dns_servers         = var.dns_servers
  tags                = local.tags
}

# resource "azurerm_virtual_network_peering" "example-1" {
#   name                      = "peer1to2"
#   resource_group_name       = azurerm_resource_group.example.name
#   virtual_network_name      = azurerm_virtual_network.example-1.name
#   remote_virtual_network_id = azurerm_virtual_network.example-2.id
# }