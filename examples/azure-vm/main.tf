/**
* # azure-vm
* 
* This directory can stand up Linux and Windows VMs
* 
* ## How To Use
*
* ### Linux VM without Public IP
*
* ```terraform
* module "vm" {
*   source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-vm"
*   vm_count_linux      = 1
*   environment         = var.environment
*   application         = var.application
*   resource_group_name = azurerm_resource_group.rg.name
*   location            = var.location
*   business            = var.business
*   service             = var.service
*   subnet_id           = module.subnet.subnet_id
*   vm_size             = var.vm_size
*   admin_password      = var.admin_password
* 
*   source_image_reference = {
*     publisher = "RedHat"
*     offer     = "RHEL"
*     sku       = "7-RAW-CI"
*     version   = "latest"
*   }
*  }
* ```
*
* ### Windows VM without Public IP
*
* ```terraform
* module "vm" {
*   source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-vm"
*   vm_count_windows    = 1
*   environment         = var.environment
*   application         = var.application
*   resource_group_name = azurerm_resource_group.rg.name
*   location            = var.location
*   business            = var.business
*   service             = var.service
*   subnet_id           = module.subnet.subnet_id
*   vm_size             = var.vm_size
*   admin_password      = var.admin_password
* 
*   source_image_reference = {
*     publisher = "MicrosoftWindowsServer"
*     offer     = "WindowsServer"
*     sku       = "2016-Datacenter"
*     version   = "latest"
*   }
*  }
* ```
*
* ### Linux VM with Log Analytics Integration
*
* ```terraform
* module "vm" {
*   source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-vm"
*   vm_count_linux      = 1
*   environment         = var.environment
*   application         = var.application
*   resource_group_name = azurerm_resource_group.rg.name
*   location            = var.location
*   business            = var.business
*   service             = var.service
*   subnet_id           = module.subnet.subnet_id
*   vm_size             = var.vm_size
*   admin_password      = var.admin_password
*   log_workspace_integration = {
*       enabled = true
*       workspace_id          = module.law.workspace_customer_id
*       workspace_key         = module.law.workspace_primary_key
*   }
* 
*   source_image_reference = {
*     publisher = "RedHat"
*     offer     = "RHEL"
*     sku       = "7-RAW-CI"
*     version   = "latest"
*   }
*  }
* ```
*
* ### Windows VM with disks and disk partition setup
*
* ```hcl
* module "vm" {
*   source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-vm"
*   vm_count_windows    = 1
*   environment         = var.environment
*   application         = var.application
*   resource_group_name = azurerm_resource_group.rg.name
*   location            = var.location
*   business            = var.business
*   service             = var.service
*   subnet_id           = module.subnet.subnet_id
*   vm_size             = var.vm_size
*   admin_password      = var.admin_password
* 
*   source_image_reference = {
*     publisher = "MicrosoftWindowsServer"
*     offer     = "WindowsServer"
*     sku       = "2016-Datacenter"
*     version   = "latest"
*   }
*   init_scripts           = ["data_disk"]
*   disk_count_windows     = 2
*   disk_sizes_windows     = [100, 100]
*   disk_skus_windows      = ["Premium_LRS", "Premium_LRS"]
*   disk_caching_windows   = ["ReadWrite", "ReadWrite"]
*   data_disk              = [
*     {
*       drive_letter         = "e"
*       label                = "data"
*       disk_luns            = [0,1]
*       interleave           = 65536
*       allocation_unit_size = 65536
*     }
*   ]
* }
* ```
* 
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

// if you do not specify an existing resurce group one will be created for you,
// when supplying the resource group name to a resource declaration you should use
// the data type i.e 'data.azurerm_resource_group.rg.name'
resource "azurerm_resource_group" "rg" {
  count    = var.resource_group_name == "" ? 1 : 0
  name     = "${var.environment}-${var.application}-vm-${var.location}"
  location = var.location
  tags     = local.tags
}
