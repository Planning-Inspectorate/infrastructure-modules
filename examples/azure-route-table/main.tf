/**
* # azure-route-table
* 
* This directory deploys a route table with optional routes
* 
* ## How To Use
* 
* Include example code snippets:
*
* ### Example One
*
* ```terraform
* module "rt" {
*   source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-route-table"
*   environment = "dev"
*   application = "app"
*   location    = "northeurope"
*   routes = [
*     {
*       name                   = "internet"
*       address_prefix         = "0.0.0.0/0"
*       next_hop_type          = "Internet"
*       next_hop_in_ip_address = "null"
*     }
*   ]
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
  name     = "${var.environment}-${var.application}-route-table-${var.location}"
  location = var.location
  tags     = local.tags
}


resource "azurerm_route_table" "rt" {
  name                          = "${var.environment}-${var.application}-rt-${var.location}"
  location                      = var.location
  resource_group_name           = data.azurerm_resource_group.rg.name
  disable_bgp_route_propagation = false

  dynamic "route" {
    for_each = [for r in var.routes : {
      name                   = r.name
      address_prefix         = r.address_prefix
      next_hop_type          = r.next_hop_type
      next_hop_in_ip_address = r.next_hop_in_ip_address
    }]

    content {
      name                   = route.value.name
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = route.value.next_hop_type == "VirtualAppliance" ? route.value.next_hop_in_ip_address : null
    }
  }

  tags = local.tags
}