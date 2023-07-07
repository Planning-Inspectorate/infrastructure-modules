/**
* # azure-firewall
* 
* CI for Azure Firewall
* 
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

module "fw" {
  source              = "../../azure-firewall"
  resource_group_name = var.vnet_rg
  environment         = var.environment
  application         = var.application
  location            = var.location
  subnet_id           = data.azurerm_subnet.fw.id
  tags                = var.tags
}