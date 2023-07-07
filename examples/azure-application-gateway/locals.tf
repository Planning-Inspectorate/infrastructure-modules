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

  subnet_id_elements = split("/", var.subnet_id)

  request_routing_rules = [
    for r in var.request_routing_rules : merge({
      rewrite_rule_set_name = null
    }, r)
  ]

}
