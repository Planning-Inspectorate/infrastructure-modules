/**
* # azure-databricks
*
* CI for databricks
* 
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and * output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

module "databricks" {
  source                  = "../../azure-databricks"
  environment             = var.environment
  application             = var.application
  location                = var.location
  sku                     = var.sku
  spark_version           = var.spark_version
  node_type_id            = var.node_type_id
  autotermination_minutes = var.autotermination_minutes
  autoscale               = var.autoscale
  tags                    = var.tags
}