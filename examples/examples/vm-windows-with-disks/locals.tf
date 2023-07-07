/*
    Terraform configuration file defining provider configuration
*/
locals {
  tags = merge(
    tomap({
      application = var.application,
      environment = var.environment,
      patching    = var.patching,
      repo        = "https://dev.azure.com/hiscox/gp-psg/_git/terraform-modules"
    }),
    var.tags
  )
}
