/**
* # azure-sql-managed-instance
* 
* CI for SQL managed
*
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: [terraform-docs](https://github.com/segmentio/terraform-docs)
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

module "sql_managed" {
  source              = "../../azuresql-managed"
  environment         = var.environment
  application         = var.application
  location            = var.location
  vnet_resource_group = var.vnet_resource_group
  vnet_name           = var.vnet_name
  subnet_name         = var.subnet_name
  cores               = var.cores
  storage_size        = var.storage_size
  tags                = var.tags
}