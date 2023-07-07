/**
* # WebApp integrated Application Gateway 
* 
* This code is a demonstration of a webapp hosted on App Gateway. 
* 
* The code creates the required app service (with a dummy hello world docker image running) and then fronts 
* it with a Application Gateway (AAG) and Web Application Firewall (WAF) policy that provide protection against
* most common web vulnerabilities and attacks. The AAG uses the private IP in the backend pool and the host name
* is overridden in the http settings. The App services access restrictions are configured to allow traffic from
* the AGG IP address only.
* 
* In addition it adds records into Infoblox DNS to allow the webapp internal IP to be recognised. 
* This is to allow the Application Gateway to rewrite the headers from the friendly Hiscox name to the webapp URL
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
* ```pwsh
* Connect-AzAccount
* Set-AzContext -SubscriptionName 'hiscox its psgtest devtest'
* Export-AzViz -ResourceGroup ci-examplewebaag-webaag-northeurope -Theme light -OutputFormat png -OutputFilePath 'diagrams/design.png' -CategoryDepth 1 -LabelVerbosity 2 -ExcludeTypes Microsoft.Network/applicationGateways
* ```
*/

resource "azurerm_resource_group" "resource_group" {
  name     = "${var.environment}-${var.application}-webaag-${var.location}"
  location = var.location
  tags     = local.tags
}

module "asp" {
  source              = "../../azure-app-service-plan"
  resource_group_name = azurerm_resource_group.resource_group.name
  environment         = var.environment
  application         = var.application
  location            = var.location
  tags                = local.tags
  sku                 = var.sku
}

module "as" {
  source              = "../../azure-app-service-web"
  app_service_plan_id = module.asp.id
  resource_group_name = azurerm_resource_group.resource_group.name
  environment         = var.environment
  application         = var.application
  location            = var.location
  tags                = local.tags
  site_config         = local.site_config_merged
  app_settings        = var.app_settings
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
  resource_group_name = azurerm_resource_group.resource_group.name
  environment         = var.environment
  application         = var.application
  location            = var.location
  tags                = local.tags
  subnet_id           = module.subnet.subnet_id
  backend_pool = [
    {
      name  = "webapp"
      fqdns = [module.as.app_service_default_hostname]
    }
  ]
  http_listeners = [
    {
      name                           = "website-insecure"
      frontend_ip_configuration_name = "privateip"
      host_name                      = var.fqdn_url
      frontend_port_name             = "insecure"
      protocol                       = "Http"
      ssl_certificate_name           = null
    }
  ]
  probes = [
    {
      name                = "webapp"
      interval            = 30
      protocol            = "http"
      path                = "/"
      timeout             = 30
      unhealthy_threshold = 3
      host                = module.as.app_service_default_hostname
    }
  ]
  backend_http_settings = [
    {
      name                  = "website-backend-settings"
      cookie_based_affinity = "Enabled"
      port                  = 80
      protocol              = "Http"
      request_timeout       = "10"
      probe_name            = "webapp"
    }
  ]
  request_routing_rules = [
    {
      name                        = "webapp-route"
      rule_type                   = "Basic"
      http_listener_name          = "website-insecure"
      backend_address_pool_name   = "webapp"
      backend_http_settings_name  = "website-backend-settings"
      redirect_configuration_name = null
      rewrite_rule_set_name       = "webapp-header-set"
    }
  ]
  rewrite_rule_set = [{
    set_name      = "webapp-header-set"
    rule_name     = "header-rule"
    rule_sequence = 100
    header_name   = "Host"
    header_value  = module.as.app_service_default_hostname
  }]
  depends_on = [
    module.subnet,
    module.nsg
  ]
}

module "nsg" {
  source              = "../../azure-network-security-group"
  environment         = var.environment
  application         = var.application
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location
  tags                = local.tags
  nsg_in_rules        = var.nsg_in_rules
  nsg_out_rules       = var.nsg_out_rules
}

resource "infoblox_a_record" "webapp_url" {
  fqdn     = var.fqdn_url
  ip_addr  = module.gateway.private_ip
  ttl      = 300
  dns_view = var.infoblox_view
}
