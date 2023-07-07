/**
* # vm-windows-with-disks
* 
* An example deployment of a Windows based VM with additional data disks
* 
* ## How To Update this README.md
*
* terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*
* ## Diagrams
*
* ![image info](./diagrams/design.png)
*
* Unfortunately a number of tools that can parse Terraform code/statefiles and generate architetcure diagrams are limited and most are in their infancy. The built in `terraform graph` is only really useful for looking at dependencies and is too verbose to be considered a diagram on an environment.
*
* We can however turn this on its head and look at using deployed resources to produce a diagram as a stop gap. AzViz is a tool which takes one or more resource groups as input and it will parse their contents and produce a more architecture-like diagram. It will also work out the relation between different resources. Check out all its features [here](https://github.com/PrateekKumarSingh/AzViz). To use it to store a diagram post deployment:
*
* ```pwsh
* Connect-AzAccount
* Set-AzContext -Subscription 'xxxx-xxxx'
* Export-AzViz -ResourceGroup my-resource-group-1, my-rg-2 -Theme light -OutputFormat png -OutputFilePath 'diagrams/design.png' -CategoryDepth 1 -LabelVerbosity 2
* ```
*/

resource "azurerm_resource_group" "rg" {
  name     = "${var.environment}-${var.application}-windows-${var.location}"
  location = var.location
  tags     = local.tags
}

module "vm" {
  //source                   = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-vm?ref=master"
  source                 = "../../azure-vm"
  vm_count_windows       = 2
  environment            = var.environment
  server_environment     = var.server_environment
  application            = var.application
  resource_group_name    = azurerm_resource_group.rg.name
  location               = var.location
  business               = var.business
  service                = var.service
  subnet_id              = data.azurerm_subnet.subnet.id
  vm_size                = var.vm_size
  admin_password         = sensitive(data.azurerm_key_vault_secret.admin_password.value)
  source_image_reference = var.source_image_reference
  init_scripts           = ["data_disk", "puppet_agent"]
  disk_count_windows     = 2
  disk_sizes_windows     = [100, 100]
  disk_skus_windows      = ["Premium_LRS", "Premium_LRS"]
  disk_caching_windows   = ["ReadWrite", "ReadWrite"]
  data_disk = [
    {
      drive_letter         = "e"
      label                = "data"
      disk_luns            = [0, 1]
      interleave           = 65536
      allocation_unit_size = 65536
    }
  ]
}