/**
* # azure-bastion
*
* CI for bastion
*
* ## How To Update this README.md
*
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

module "bastion" {
  source                   = "../../azure-bastion"
  environment              = var.environment
  application              = var.application
  location                 = var.location
  service_name_environment = var.service_name_environment
  service_name_business    = var.service_name_business
  vnet                     = var.vnet
  vnet_resource_group_name = var.vnet_resource_group_name
  subnet_cidr              = var.subnet_cidr
  tags                     = var.tags
}
