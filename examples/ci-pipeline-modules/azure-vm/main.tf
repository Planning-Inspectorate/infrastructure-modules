/**
* # azure-vm
* 
* CI for VMs
*
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

# module "vm" {
#   source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-vm"
#   vm_count_linux      = 1
#   environment         = var.environment
#   application         = var.application
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = var.location
#   business            = var.business
#   service             = var.service
#   subnet_id           = module.subnet.subnet_id
#   vm_size             = var.vm_size
#   admin_password      = var.admin_password

#   source_image_reference = {
#     publisher = "RedHat"
#     offer     = "RHEL"
#     sku       = "7-RAW-CI"
#     version   = "latest"
#   }
#  }