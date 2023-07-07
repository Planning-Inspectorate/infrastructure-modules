/*
    Terraform configuration file defining provider configuration
*/
locals {
  tags = merge(
    tomap({
      application = var.application,
      environment = var.environment,
      repo        = "https://dev.azure.com/hiscox/gp-psg/_git/terraform-modules",
      created     = time_static.t.rfc3339
    }),
    var.tags
  )

  site_config = {
    ip_restrictions = {
      subnet_ids = []
      ip_addresses = [
        {
          rule_name  = "IPRestriction"
          ip_address = "${module.gateway.public_ip}/32"
          priority   = 100
          action     = "Allow"
        },
        {
          rule_name  = "DenyAll"
          ip_address = "0.0.0.0/0"
          priority   = 200
          action     = "Deny"
        }
      ]
      service_tags = []
    }
  }

  site_config_merged = merge(local.site_config, var.site_config)

}
