/**
* # app-gateway-firewall
* 
* This example creates a dedicated subnet for hosting an Azure Application Gateway as a Web Application Firewall
* 
* ## How To Update this README.md
*
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*
* ## Diagrams
*
* ![image info](./diagrams/design.png)
*
* Unfortunately a number of tools that can parse Terraform code/statefiles and generate architetcure diagrams are limited and most are in their infancy. The built in `terraform graph` is only really useful for looking at dependencies and is too verbose to be considered a diagram on an environment.
*
* We can however turn this on its head and look at using deployed resources to produce a diagram as a stop gap. AzViz is a tool which takes one or more resource groups as input and it will parse their contents and produce a more architecture-like diagram. It will also work out the relation between different resources. Check out all its features [here](https://github.com/PrateekKumarSingh/AzViz). To use it to store a diagram post deployment:
*
* ```pwsh
* Connect-AzAccount
* Set-AzContext -Subscription 'xxxx-xxxx'
* Export-AzViz -ResourceGroup my-resource-group-1, my-rg-2 -Theme light -OutputFormat png -OutputFilePath 'diagrams/design.png' -CategoryDepth 1 -LabelVerbosity 2
* ```
*/

resource "azurerm_resource_group" "gateway" {
  name     = "${var.environment}-${var.application}-waf-${var.location}"
  location = var.location
  tags     = local.tags
}

module "subnet" {
  source                    = "../../azure-subnet"
  subnet_name               = var.subnet_name
  vnet_resource_group_name  = var.vnet_resource_group_name
  virtual_network_name      = var.vnet_name
  address_prefixes          = var.address_prefixes
  service_endpoints         = ["Microsoft.KeyVault"]
  network_security_group_id = [module.nsg.network_security_group_id]
}

module "gateway" {
  source              = "../../azure-application-gateway"
  resource_group_name = azurerm_resource_group.gateway.name
  environment         = var.environment
  application         = var.application
  location            = var.location
  tags                = local.tags
  subnet_id           = module.subnet.subnet_id
  backend_pool = [
    {
      name  = "ci"
      fqdns = ["notfake.azure.hiscox.com"]
    }
  ]
  http_listeners = [
    {
      name                           = "website-insecure"
      frontend_ip_configuration_name = "privateip"
      host_name                      = "somehostname.bacon.com"
      frontend_port_name             = "insecure"
      protocol                       = "Http"
      ssl_certificate_name           = null
    }
  ]
  probes = [
    {
      name                = "ci"
      interval            = 30
      protocol            = "http"
      path                = "/healthcheck"
      timeout             = 30
      unhealthy_threshold = 3
      host                = "notfake.azure.hiscox.com"
    }
  ]
  backend_http_settings = [
    {
      name                  = "website-backend-settings"
      cookie_based_affinity = "Enabled"
      port                  = 80
      protocol              = "Http"
      request_timeout       = "10"
      probe_name            = "ci"
    }
  ]
  request_routing_rules = [
    {
      name                        = "ci-route"
      rule_type                   = "Basic"
      http_listener_name          = "website-insecure"
      backend_address_pool_name   = "ci"
      backend_http_settings_name  = "website-backend-settings"
      redirect_configuration_name = null
    }
  ]
  depends_on = [
    module.subnet,
    module.nsg
  ]
}

module "log_workspace" {
  source              = "../../azure-log-analytics"
  resource_group_name = azurerm_resource_group.gateway.name
  environment         = var.environment
  application         = var.application
  location            = var.location
  tags                = local.tags
}

module "nsg" {
  source              = "../../azure-network-security-group"
  environment         = var.environment
  application         = var.application
  resource_group_name = azurerm_resource_group.gateway.name
  location            = var.location
  nsg_in_rules        = var.nsg_in_rules
  nsg_out_rules       = var.nsg_out_rules
}
