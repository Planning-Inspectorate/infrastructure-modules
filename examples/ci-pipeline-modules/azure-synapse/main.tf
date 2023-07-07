/**
* # azure-synapse
* 
* CI for Synapse
*
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

module "storage" {
  source                 = "../../azure-storage-account"
  environment            = var.environment
  application            = var.application
  location               = var.location
  network_rule_bypass    = ["AzureServices"]
}

module "azure-synapse" {
  source                        = "../../azure-synapse"
  resource_group_name           = module.storage.resource_group_name
  environment                   = var.environment
  application                   = var.application
  location                      = var.location
  storage_account_id            = module.storage.storage_id
  public_network_access_enabled = "true"
  aad_admin_user                = var.aad_admin_user
}