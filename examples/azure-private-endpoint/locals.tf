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
    var.tags,
  )

  subscription_id              = element(split("/", var.private_connection_resource_id), 2)
  resource_group_name          = element(split("/", var.private_connection_resource_id), 4)
  provider_name                = element(split("/", var.private_connection_resource_id), 6)
  resource_provider_type       = element(split("/", var.private_connection_resource_id), 7)
  resource_name                = element(split("/", var.private_connection_resource_id), 8)
  child_resource_provider_type = element(split("/", var.private_connection_resource_id), 9)
  child_resource_name          = element(split("/", var.private_connection_resource_id), 10)
}
