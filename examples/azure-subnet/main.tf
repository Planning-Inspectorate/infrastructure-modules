/**
* # azure-subnet
* 
* This will create a subnet.
* 
* ## How To Use
*
* Outputs should be used as inputs in a parent module
*
* ## Basic Subnet
*
* ```terraform
* module "subnet" {
*   source                    = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-subnet"
*   subnet_name               = "dev"
*   vnet_resource_group_name  = "resourcegroup"
*   virtual_network_name      = "vnet"
*   address_prefixes          = ["198.162.0.0/24"]
*  }
* ```
*
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

resource "azurerm_subnet" "subnet" {
  name                                           = var.subnet_name
  resource_group_name                            = var.vnet_resource_group_name
  virtual_network_name                           = var.virtual_network_name
  address_prefixes                               = var.address_prefixes
  service_endpoints                              = var.service_endpoints
  enforce_private_link_endpoint_network_policies = var.enforce_private_link_endpoint_network_policies
  enforce_private_link_service_network_policies  = var.enforce_private_link_service_network_policies

  dynamic "delegation" {
    for_each = var.delegation
    content {
      name = delegation.value["name"]
      service_delegation {
        name    = delegation.value["service_delegation_name"]
        actions = delegation.value["service_delegation_actions"]
      }
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  count                     = length(var.network_security_group_id) == 0 ? 0 : 1
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = var.network_security_group_id[0]
}

resource "azurerm_subnet_route_table_association" "example" {
  count          = length(var.route_table_id) == 0 ? 0 : 1
  subnet_id      = azurerm_subnet.subnet.id
  route_table_id = var.route_table_id[0]
}
