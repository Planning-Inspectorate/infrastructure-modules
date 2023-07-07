/**
* # azure-application-gateway
* 
* This repository will provision Azure Application Gateway.
* 
* ## How To Use
* 
* Use an existing tfvar environment file as a guide. This module is rather conplex due to the number of dynamic blocks in motion.
* 
* The properties of an Azure Application Gateway are constructed from lists of maps which are looped through in the resource definition.
*
* ```HCL
* module "gateway" {
*   source = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-application-gateway"
*   resource_group_name = azurerm_resource_group.gateway.name
*   environment         = var.environment
*   application         = var.application
*   location            = var.location
*   tags                = local.tags
*   subnet_id           = module.subnet.subnet_id
*   backend_pool = [
*     {
*       name  = "ci"
*       fqdns = ["notfake.azure.hiscox.com"]
*     }
*   ]
*   http_listeners = [
*     {
*       name                           = "website-insecure"
*       frontend_ip_configuration_name = "privateip"
*       host_name                      = "somehostname.bacon.com"
*       frontend_port_name             = "insecure"
*       protocol                       = "Http"
*       ssl_certificate_name           = null
*     }
*   ]
*   probes = [
*     {
*       name                = "ci"
*       interval            = 30
*       protocol            = "http"
*       path                = "/healthcheck"
*       timeout             = 30
*       unhealthy_threshold = 3
*       host                = "notfake.azure.hiscox.com"
*     }
*   ]
*   backend_http_settings = [
*     {
*       name                  = "website-backend-settings"
*       cookie_based_affinity = "Enabled"
*       port                  = 80
*       protocol              = "Http"
*       request_timeout       = "10"
*       probe_name            = "ci"
*     }
*   ]
*   request_routing_rules = [
*     {
*       name                        = "ci-route"
*       rule_type                   = "Basic"
*       http_listener_name          = "website-insecure"
*       backend_address_pool_name   = "ci"
*       backend_http_settings_name  = "website-backend-settings"
*       redirect_configuration_name = null
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
  name     = "${var.environment}-${var.application}-aag-${var.location}"
  location = var.location
  tags     = local.tags
}

resource "azurerm_public_ip" "public_ip" {
  name                = "${var.environment}-${var.application}-aag-publicip-${var.location}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.tags
}

resource "azurerm_web_application_firewall_policy" "waf_policy" {
  name                = "${var.environment}${var.application}fwp${var.location}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location

  policy_settings {
    enabled            = true
    mode               = var.waf_configuration_firewall_mode
    request_body_check = true
  }

  managed_rules {

    dynamic "exclusion" {
      for_each = [for e in var.exclusions : {
        match_variable          = e.match_variable
        selector_match_operator = e.selector_match_operator
        selector                = e.selector
      }]

      content {
        match_variable          = exclusion.value.match_variable
        selector_match_operator = exclusion.value.selector_match_operator
        selector                = exclusion.value.selector
      }
    }

    managed_rule_set {
      type    = "OWASP"
      version = "3.1"
      dynamic "rule_group_override" {
        for_each = [for drg in var.disabled_rule_groups : {
          rule_group_name = drg.rule_group_name.0
          disabled_rules  = drg.rules
        }]

        content {
          rule_group_name = rule_group_override.value.rule_group_name
          disabled_rules  = rule_group_override.value.rule_group_override
        }
      }
    }

    managed_rule_set {
      type    = "Microsoft_BotManagerRuleSet"
      version = "0.1"
    }
  }

}

resource "azurerm_application_gateway" "waf" {
  name                = "${var.environment}-${var.application}-aag-${var.location}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location
  enable_http2        = true
  tags                = local.tags

  autoscale_configuration {
    min_capacity = 2
    max_capacity = var.autoscale_max_capacity
  }

  ssl_policy {
    policy_type          = "Custom"
    min_protocol_version = "TLSv1_2"
    cipher_suites        = var.ciphers
  }

  sku {
    name = var.sku_name
    tier = var.sku_tier
  }

  firewall_policy_id = azurerm_web_application_firewall_policy.waf_policy.id

  gateway_ip_configuration {
    name      = "waf-gateway-ip-configuration"
    subnet_id = var.subnet_id
  }

  frontend_port {
    name = "insecure"
    port = 80
  }

  frontend_port {
    name = "secure"
    port = 443
  }

  frontend_ip_configuration {
    name                          = "privateip"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "static"
    private_ip_address            = cidrhost(data.azurerm_subnet.sn.address_prefixes[0], -2)
  }

  frontend_ip_configuration {
    name                 = "publicip"
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }

  # backend target traffic should be directed to
  dynamic "backend_address_pool" {
    for_each = [for b in var.backend_pool : {
      name  = b.name
      fqdns = b.fqdns
    }]

    content {
      name  = backend_address_pool.value.name
      fqdns = backend_address_pool.value.fqdns
      #ip_addresses = lookup(backend_pool.0.value, "ips", null)
    }
  }

  // TODO: dyanmic certs
  # SSL certificate must be a pfx file with a password
  # ssl_certificate {
  #   name     = var.cert_name
  #   data     = "${filebase64(var.cert)}"
  #   password = data.azurerm_key_vault_secret.cert.value
  # }

  dynamic "http_listener" {
    for_each = [for h in var.http_listeners : {
      name                           = h.name
      frontend_ip_configuration_name = h.frontend_ip_configuration_name
      host_name                      = h.host_name
      frontend_port_name             = h.frontend_port_name
      protocol                       = h.protocol
      ssl_certificate_name           = h.ssl_certificate_name
    }]

    content {
      name                           = http_listener.value.name
      frontend_ip_configuration_name = http_listener.value.frontend_ip_configuration_name
      host_name                      = http_listener.value.host_name
      frontend_port_name             = http_listener.value.frontend_port_name
      protocol                       = http_listener.value.protocol
      ssl_certificate_name           = http_listener.value.ssl_certificate_name
    }
  }

  dynamic "probe" {
    for_each = [for p in var.probes : {
      name                = p.name
      interval            = p.interval
      protocol            = p.protocol
      path                = p.path
      timeout             = p.timeout
      unhealthy_threshold = p.unhealthy_threshold
      host                = p.host
    }]

    content {
      name                = probe.value.name
      interval            = probe.value.interval
      protocol            = probe.value.protocol
      path                = probe.value.path
      timeout             = probe.value.timeout
      unhealthy_threshold = probe.value.unhealthy_threshold
      host                = probe.value.host
    }
  }

  // cluster identity http
  dynamic "backend_http_settings" {
    for_each = [for bhs in var.backend_http_settings : {
      name                  = bhs.name
      cookie_based_affinity = bhs.cookie_based_affinity
      port                  = bhs.port
      protocol              = bhs.protocol
      request_timeout       = bhs.request_timeout
      probe_name            = bhs.probe_name
    }]

    content {
      name                  = backend_http_settings.value.name
      cookie_based_affinity = backend_http_settings.value.cookie_based_affinity
      port                  = backend_http_settings.value.port
      protocol              = backend_http_settings.value.protocol
      request_timeout       = backend_http_settings.value.request_timeout
      probe_name            = backend_http_settings.value.probe_name
      connection_draining {
        enabled           = true
        drain_timeout_sec = 60
      }
    }
  }

  // redirection
  dynamic "redirect_configuration" {
    for_each = [for r in var.redirections : {
      name                 = r.name
      redirect_type        = r.redirect_type
      target_listener_name = r.target_listener_name
      target_url           = r.target_url
      include_path         = r.include_path
      include_query_string = r.include_query_string
    }]

    content {
      name                 = redirect_configuration.value.name
      redirect_type        = redirect_configuration.value.redirect_type
      target_listener_name = redirect_configuration.value.target_listener_name
      target_url           = redirect_configuration.value.target_url
      include_path         = redirect_configuration.value.include_path
      include_query_string = redirect_configuration.value.include_query_string
    }
  }

  # Request rules
  dynamic "request_routing_rule" {
    for_each = [for rrr in local.request_routing_rules : {
      name                        = rrr.name
      rule_type                   = rrr.rule_type
      http_listener_name          = rrr.http_listener_name
      backend_address_pool_name   = rrr.backend_address_pool_name
      backend_http_settings_name  = rrr.backend_http_settings_name
      redirect_configuration_name = rrr.redirect_configuration_name
      rewrite_rule_set_name       = rrr.rewrite_rule_set_name
    }]

    content {
      name                        = request_routing_rule.value.name
      rule_type                   = request_routing_rule.value.rule_type
      http_listener_name          = request_routing_rule.value.http_listener_name
      backend_address_pool_name   = request_routing_rule.value.backend_address_pool_name
      backend_http_settings_name  = request_routing_rule.value.backend_http_settings_name
      redirect_configuration_name = request_routing_rule.value.redirect_configuration_name
      rewrite_rule_set_name       = request_routing_rule.value.rewrite_rule_set_name
    }
  }

  # Rewrite rules
  dynamic "rewrite_rule_set" {
    for_each = [for rrs in var.rewrite_rule_set : {
      set_name      = rrs.set_name
      rule_name     = rrs.rule_name
      rule_sequence = rrs.rule_sequence
      header_name   = rrs.header_name
      header_value  = rrs.header_value
    }]
    content {
      name = rewrite_rule_set.value.set_name
      rewrite_rule {
        name          = rewrite_rule_set.value.rule_name
        rule_sequence = rewrite_rule_set.value.rule_sequence
        request_header_configuration {
          header_name  = rewrite_rule_set.value.header_name
          header_value = rewrite_rule_set.value.header_value
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      http_listener,
      request_routing_rule,
      ssl_certificate
    ]
  }

  //depends_on = ["azurerm_network_security_rule.nsg-in"]
}

