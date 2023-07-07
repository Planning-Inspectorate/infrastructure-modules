/*
    Terraform configuration file defining provider configuration
*/
locals {
  tags = merge(
    tomap({
      application = var.application,
      environment = var.environment,
      repo        = "https://dev.azure.com/hiscox/gp-psg/_git/terraform-modules"
    }),
    var.tags
  )

  share_names = toset([for v in var.shares : v.name])

}