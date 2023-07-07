environment               = "ci"
application               = "testaag"
location                  = "northeurope"
subnet_id                 = "/subscriptions/41dac0b7-f808-4ae6-94f2-010b5cc2b358/resourceGroups/devtest-itspsg-subscription-northeurope/providers/Microsoft.Network/virtualNetworks/devtest-its-vnet-northeurope/subnets/ci-aag-pipeline"

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
disabled_rule_groups = [
  {
    rule_group_name = ["REQUEST-942-APPLICATION-ATTACK-SQLI"]
    rules           = ["942200", "942260", "942340", "942370", "942430"]
  }
]