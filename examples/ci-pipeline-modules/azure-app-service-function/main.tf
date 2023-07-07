/**
* # app-service-function
*
* CI App Service Function.
*
* ## How To Update this README.md
*
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions [here](https://github.com/segmentio/terraform-docs)
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

module "asp" {
  source      = "../../azure-app-service-plan"
  environment = var.environment
  application = var.application
  location    = var.location
  tags        = var.tags
}

module "storage" {
  // source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-storage-account"
  source                 = "../../azure-storage-account"
  environment            = var.environment
  application            = var.application
  location               = var.location
  resource_group_name    = module.asp.resource_group_name
  network_default_action = "Allow" // don't set this for real, this just makes local testing simple
  network_rule_bypass    = ["AzureServices", "Logging", "Metrics"]
}

module "func_java" {
  source                     = "../../azure-app-service-function"
  app_service_plan_id        = module.asp.id
  environment                = var.environment
  application                = var.application
  location                   = var.location
  resource_group_name        = module.asp.resource_group_name
  site_config                = var.site_config
  tags                       = var.tags
  storage_account_name       = module.storage.storage_name
  storage_account_access_key = module.storage.primary_access_key
}
