/**
* # azure-firewall-policy
* 
* CI for Azure Firewall Policy
* 
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

module "fwp" {
  source              = "../../azure-firewall-policy"
  resource_group_name = var.vnet_rg
  environment         = var.environment
  application         = var.application
  location            = var.location
  application_rules   = var.application_rules
  network_rules       = var.network_rules
  nat_rules           = var.nat_rules
  tags                = var.tags
}