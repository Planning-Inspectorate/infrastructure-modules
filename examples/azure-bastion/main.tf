/**
* # azure-bastion
*
* Provisions a Bastion PaaS service for a desired VNET
*
* ## How To Use
*
* * Inputs should be refereced in a module to create your bastion of the sort:
*
* ```
* module "bastion" {
*   source = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-bastion"
*   environment              = var.environment
*   application              = var.application
*   location                 = var.location
*   service_name_environment = var.service_name_environment
*   service_name_business    = var.service_name_business
*   vnet                     = var.vnet
*   vnet_resource_group_name = var.vnet_resource_group_name
*   subnet_cidr              = var.subnet_cidr
*   tags                     = var.tags
* }
* ```
*
* ## How To Update this README.md
*
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

resource "azurerm_resource_group" "resource_group" {
  name     = "${var.environment}-${var.application}-${var.component}-${var.location}"
  location = var.location
  tags     = local.tags
}

resource "azurerm_subnet" "bastion_subnet" {
  name                 = local.subnet_name
  resource_group_name  = var.vnet_resource_group_name
  virtual_network_name = var.vnet
  address_prefixes     = var.subnet_cidr
}

resource "azurerm_public_ip" "bastion_ip" {
  name                = "${local.name}-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.tags
}

resource "azurerm_bastion_host" "bastion" {
  name                = "${local.name}-bastion"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_ip.id
  }
  tags = local.tags
}

