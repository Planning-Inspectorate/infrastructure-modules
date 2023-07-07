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

  ids = [for v in data.azurerm_virtual_machine.puppetmaster_vm : v.identity.0.principal_id]

  puppetmaster_access_policy = [
    {
      object_ids         = local.ids
      secret_permissions = ["get", "set", "list"]
    }
  ]

  access_policies = concat(var.access_policies, local.puppetmaster_access_policy)
}
