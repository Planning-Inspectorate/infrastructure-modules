/**
* # azure-app-service-plan
* 
* CI for the Azure App Service Plan
*
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

module "asp" {
  source      = "../../azure-app-service-plan"
  environment = var.environment
  application = var.application
  location    = var.location
  tags        = var.tags
}