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

  location_codes = {
    "northeurope" = "ne"
    "westeurope"  = "we"
    "ukwest"      = "uk"
  }

  databricks_workspace_name = format("%s-%s-databricks-%s", var.environment, var.application, local.location_codes[var.location])
  databricks_cluster_name   = format("%s%sdatabricks%s", var.environment, var.application, local.location_codes[var.location])

}