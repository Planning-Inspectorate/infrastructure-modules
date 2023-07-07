/*
    Terraform configuration file defining provider configuration
*/
locals {
  name              = "${var.environment}-${var.application}"
  linux_disk_name   = var.disk_server_identity_override && var.vm_count_linux != 0 ? module.server_name_linux[0].name : local.name
  windows_disk_name = var.disk_server_identity_override && var.vm_count_windows != 0 ? module.server_name_windows[0].name : local.name

  tags = merge(
    tomap({
      application = var.application,
      environment = var.environment,
      business    = var.business,
      repo        = "https://dev.azure.com/hiscox/gp-psg/_git/terraform-modules",
      created     = time_static.t.rfc3339,
      patching    = var.patching
    }),
    var.tags,
  )
}
