/*
    Terraform configuration file defining local variables
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
}
