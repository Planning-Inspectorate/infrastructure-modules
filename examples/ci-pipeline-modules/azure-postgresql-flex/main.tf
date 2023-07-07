/**
* # azure-postgresql-flex
* 
* CI for PostgreSQL Flexible
*
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

module "postgresqlflx" {
  source                              = "../../azure-postgresql-flex"
  environment                         = var.environment
  application                         = var.application
  location                            = "northeurope"
  postgresqlflx_server_admin_password = sensitive(data.azurerm_key_vault_secret.admin_password.value)
  enable_firewall                     = false
}