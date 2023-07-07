/**
* # azure-virtual-network
* 
* CI for vnet
* 
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

module "vnet" {
  source        = "../../azure-virtual-network"
  environment   = var.environment
  application   = var.application
  location      = var.location
  address_space = var.address_space
  tags          = var.tags
}