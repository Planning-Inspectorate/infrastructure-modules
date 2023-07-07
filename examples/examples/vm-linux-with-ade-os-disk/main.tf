/**
* # vm-linux-with-ade-os-disk
* 
* An example deployment of a Linux based VM with Azure Disk Encryption enabled on an OS disk
* 
* Specific requirements exist for what version of the OS is supported for ADE. More details can be found here https://docs.microsoft.com/en-us/azure/virtual-machines/linux/disk-encryption-overview
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
  name     = "${var.environment}-${var.application}-nix-${var.location}"
  location = var.location
  tags     = local.tags
}


module "keyvault" {
  source              = "../../azure-keyvault"
  environment         = var.environment
  application         = var.application
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location

  enabled_for_deployment          = true # Required for ADE
  enabled_for_template_deployment = true # Required for ADE
  soft_delete_enabled             = true # Required for ADE
  purge_protection_enabled        = true # Required for ADE
  soft_delete_retention_days      = 7    # Optional but default is 30
  subnet_ids                      = [data.azurerm_subnet.subnet.id]
  tags                            = local.tags
}

module "vm" {
  //source                   = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-vm?ref=master"
  source                 = "../../azure-vm"
  vm_count_linux         = 2
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
  disk_os_size_linux     = var.disk_os_size_linux

  use_azure_disk_encryption = true
  ade_key_vault_uri         = module.keyvault.keyvault_uri
  ade_key_vault_id          = module.keyvault.keyvault_id
}

