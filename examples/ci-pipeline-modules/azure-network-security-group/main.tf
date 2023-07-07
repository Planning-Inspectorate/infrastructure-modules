/**
* # azure-network-security-group
* 
* CI for NSG
* 
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

module "nsg" {
  source        = "../../azure-network-security-group"
  environment   = var.environment
  application   = var.application
  location      = var.location
  nsg_in_rules  = var.nsg_in_rules
  nsg_out_rules = var.nsg_out_rules
  tags          = var.tags
}