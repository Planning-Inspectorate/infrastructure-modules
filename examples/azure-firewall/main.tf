/**
* # azure-firewall
* 
* This module deploys an Azure Firewall. They need no more than a /26 address space to function and the Firewall must be in the same resource group as the corresponding subnet.
* 
* ## How To Use
* 
* Include example code snippets:
*
* ### Example
*
* ```terraform
* module "fw" {
*   source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-firewall"
*   resource_group_name = var.vnet_rg
*   environment = var.environment
*   application = var.application
*   location    = var.location
*   subnet_id   = data.azurerm_subnet.fw.id
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

resource "azurerm_public_ip" "pip" {
  name                = "${var.environment}-${var.application}-fw-publicip-${var.location}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard" # firewall only supports standard
  allocation_method   = "Static"
  tags                = local.tags
}

resource "azurerm_firewall" "fw" {
  name                = "${var.environment}-${var.application}-fw-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name
  sku_tier            = var.sku_tier
  private_ip_ranges   = ["IANAPrivateRanges"]
  firewall_policy_id  = var.firewall_policy_id

  ip_configuration {
    name                 = "default"
    subnet_id            = var.subnet_id
    public_ip_address_id = azurerm_public_ip.pip.id
  }
}
