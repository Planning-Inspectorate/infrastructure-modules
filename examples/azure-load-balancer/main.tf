/**
* # azure-load-balancer
* 
* Creates a load balancer with rules
* 
* ## How To Use
*
* ### Load Balancer with probe, backend and rule
*
* ```terraform
* module "lb" {
*   source              = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-load-balancer"
*   environment         = var.environment
*   application         = var.application
*   resource_group_name = azurerm_resource_group.rg.name
*   location            = var.location
*   frontend_ip_configuration = [{
*     name                          = "frontend"
*     subnet_id                     = module.subnet.subnet_id
*     private_ip_address            = null
*     private_ip_address_allocation = "Dynamic"
*     private_ip_address_version    = "IPv4"
*     public_ip_address_id          = null
*     public_ip_prefix_id           = null
*     zones                         = null
*   }]
*   probes = {
*     probe_name = {
*       port                = 8080
*       protocol            = "Tcp"
*       request_path        = null
*       interval_in_seconds = 5
*       number_of_probes    = 2
*     }
*   }
*   backend_pool_names = [
*     "defaultBackend"
*   ]
*   load_balancer_rules = {
*     rule1_name = {
*       protocol                       = "Tcp"
*       frontend_port                  = 80
*       backend_port                   = 8080
*       frontend_ip_configuration_name = "frontend"
*       backend_address_pool_name      = "defaultBackend"
*       probe_name                     = "probe_name"
*       enable_floating_ip             = false
*       idle_timeout_in_minutes        = 4
*       load_distribution              = "Default"
*       disable_outbound_snat          = false
*       enable_tcp_reset               = false
*     }
*   }
* }
* ```
*
* A single backend_pool_names will result in load_balancer_rules.backend_address_pool_name being overridden with the single vale.
* Set it to "" when defining your load_balancer_rules if you don't want to provide explicitly
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
  name     = "${var.environment}-${var.application}-lb-${var.location}"
  location = var.location
  tags     = local.tags
}

resource "azurerm_lb" "lb" {
  name                = var.name != "" ? var.name : "${var.environment}-${var.application}-lb-${var.location}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location
  sku                 = var.sku
  tags                = local.tags

  dynamic "frontend_ip_configuration" {
    for_each = var.frontend_ip_configuration
    content {
      name                          = frontend_ip_configuration.value["name"]
      subnet_id                     = frontend_ip_configuration.value["subnet_id"]
      private_ip_address            = frontend_ip_configuration.value["private_ip_address"]
      private_ip_address_allocation = frontend_ip_configuration.value["private_ip_address_allocation"]
      private_ip_address_version    = frontend_ip_configuration.value["private_ip_address_version"]
      public_ip_address_id          = frontend_ip_configuration.value["public_ip_address_id"]
      public_ip_prefix_id           = frontend_ip_configuration.value["public_ip_prefix_id"]
      zones                         = frontend_ip_configuration.value["zones"]
    }
  }
}

resource "azurerm_lb_probe" "probe" {
  for_each = var.probes

  name                = each.key
  resource_group_name = data.azurerm_resource_group.rg.name
  loadbalancer_id     = azurerm_lb.lb.id
  port                = each.value.port
  protocol            = each.value.protocol
  request_path        = each.value.request_path
  interval_in_seconds = each.value.interval_in_seconds
  number_of_probes    = each.value.number_of_probes
}

resource "azurerm_lb_backend_address_pool" "backend" {
  for_each = toset(var.backend_pool_names)

  name                = each.key
  resource_group_name = data.azurerm_resource_group.rg.name
  loadbalancer_id     = azurerm_lb.lb.id
}

resource "azurerm_lb_rule" "rule" {
  for_each = var.load_balancer_rules

  name                           = each.key
  resource_group_name            = data.azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = each.value.protocol
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port
  frontend_ip_configuration_name = each.value.frontend_ip_configuration_name
  backend_address_pool_id        = length(var.backend_pool_names) == 1 ? azurerm_lb_backend_address_pool.backend[var.backend_pool_names[0]].id : azurerm_lb_backend_address_pool.backend[each.value.backend_address_pool_name].id
  # backend_address_pool_id        = "${azurerm_lb.lb.id}/backendAddressPools/${each.value.backend_address_pool_name}"
  probe_id = azurerm_lb_probe.probe[each.value.probe_name].id
  # probe_id                       = "${azurerm_lb.lb.id}/probes/${each.value.probe_name}"
  enable_floating_ip      = each.value.enable_floating_ip
  idle_timeout_in_minutes = each.value.idle_timeout_in_minutes
  load_distribution       = each.value.load_distribution
  disable_outbound_snat   = each.value.disable_outbound_snat
  enable_tcp_reset        = each.value.enable_tcp_reset

  depends_on = [azurerm_lb_probe.probe, azurerm_lb_backend_address_pool.backend]
}

# resource "azurerm_lb_outbound_rule" "rule_out" {
#   name                    = "OutboundRule"
#   resource_group_name     = azurerm_resource_group.example.name
#   loadbalancer_id         = azurerm_lb.example.id
#   protocol                = "Tcp"
#   backend_address_pool_id = azurerm_lb_backend_address_pool.example.id
#   enable_tcp_reset
#   allocated_outbound_ports
#   idle_timeout_in_minutes 

#   frontend_ip_configuration {
#     name = "PublicIPAddress"
#   }
