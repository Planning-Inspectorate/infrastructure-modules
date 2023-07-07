/**
* # self-hosted-integration-runtime
* 
* An example consumer config for deploying Azure Data Factories with shared & linked self-hosted integration runtimes.
*
* ## How To Update this README.md
*
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
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
  name     = "${var.environment}-${var.application}-${var.location}"
  location = var.location
  tags     = local.tags
}

# Not required whilst not using certs for SHIRs

# resource "azurerm_key_vault_access_policy" "kvap" {
#   key_vault_id            = data.azurerm_key_vault.kv.id
#   tenant_id               = module.shir_vm.tenant_ids_windows[0]
#   object_id               = module.shir_vm.principal_ids_windows[0]
#   certificate_permissions = [
#     "get",
#   ]
#   secret_permissions      = [
#     "get",
#   ]
# }

module "df1" {
  source              = "../../azure-data-factory"
  resource_group_name = azurerm_resource_group.rg.name
  environment         = var.environment
  application         = var.application
  location            = var.location
  tags                = local.tags
}

module "df2" {
  source              = "../../azure-data-factory"
  resource_group_name = azurerm_resource_group.rg.name
  environment         = var.environment
  application         = "${var.application}2"
  location            = var.location
  depends_on = [
    module.shir_vm,
  ]
}


# This example uses the time provider to add a delay after the SHIR VM is created, to give the integration 
# runtime package time to install and register with the df1 data factory instance (created by the df1 module), before proceeding
# to create the standalone df2 data factory resource and then call the linked_shir module to create the linked
# SHIR instance in df2.
resource "time_sleep" "wait_600_seconds" {
  depends_on = [module.shir_vm]

  create_duration = "600s"
}

module "shir_vm" {
  source              = "../../azure-vm"
  vm_count_windows    = var.vm_count_windows
  environment         = var.environment
  server_environment  = var.server_environment
  application         = var.application
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  business            = var.business
  service             = var.service
  subnet_id           = data.azurerm_subnet.subnet.id
  vm_size             = var.vm_size
  admin_password      = sensitive(var.admin_password)
  tags                = local.tags

  source_image_reference = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  # Normally we'd include puppet and other scripts with their required variables here as well....
  init_scripts                       = ["integration_runtime"]
  shir_auth_key                      = sensitive(module.shir.shir_auth_keys[0])
  shir_certificate_domain            = var.shir_certificate_domain
  shir_certificate_name              = var.shir_certificate_name
  shir_secret_name                   = sensitive(var.shir_secret_name)
  shir_key_vault_name                = var.shir_key_vault_name
  shir_key_vault_resource_group_name = var.shir_key_vault_resource_group_name
}

module "shir" {
  source                           = "../../azure-self-hosted-integration-runtime"
  environment                      = var.environment
  application                      = var.application
  location                         = var.location
  data_factory_name                = module.df1.data_factory_name
  data_factory_resource_group_name = module.df1.resource_group_name
  tags                             = local.tags
  depends_on = [
    module.df1
  ]
}

# Watch out for errors with this module - it will fail if the node from the shir_vm module
# has not registered with ADF when it tries to create the linked shir
module "linked_shir" {
  source                           = "../../azure-self-hosted-integration-runtime"
  environment                      = var.environment
  application                      = var.application
  location                         = var.location
  data_factory_name                = module.df2.data_factory_name
  data_factory_resource_group_name = module.df2.resource_group_name
  linked_shir = {
    name                             = module.shir.shir_name
    data_factory_name                = module.df1.data_factory_name
    data_factory_resource_group_name = azurerm_resource_group.rg.name
  }
  tags = local.tags

  depends_on = [
    module.shir,
    module.shir_vm,
    module.df2,
    module.df1,
    time_sleep.wait_600_seconds
  ]
}
