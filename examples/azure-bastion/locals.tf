module "server_name" {
  source      = "../azure-vm/server-identification"
  environment = var.service_name_environment
  business    = var.service_name_business
  service     = var.service_name_service
}

locals {
  subnet_name = "AzureBastionSubnet"
  name        = module.server_name.name
  tags = merge(
    {
      "environment" = var.environment
      "application" = var.application
      "component"   = var.component
      "repo"        = "https://dev.azure.com/hiscox/gp-psg/_git/terraform-modules",
      "created"     = time_static.t.rfc3339
    },
    var.tags
  )
}

