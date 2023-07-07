/**
* # Synapse Workspace 
* 
* This code is a demonstration of a Synapse Workspace deployment. The example includes the creation of a SQL pool and additional data lake gen2 filesystems (using storage account module). A pre-requisite data lake gen2 filesystem,
* which is used as the "primary" storage account for a Synapse workspace, is also created within the Synapse module. The example also creates a Azure Active Directory Admin user.
*
* The Synapse module sets 'public_network_access_enabled' to false by default, requiring a private endpoint to manage connectivity, which is our recommended design. This example however explicitly sets public access
* to "true" as private endpoints are out of scope of the example. In this scenario the module will create a series of default firewall rules, but consumer code should create further rules dependant on requirements.
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
  name     = "${var.environment}-${var.application}-synapse-${var.location}"
  location = var.location
  tags     = local.tags
}

module "storage" {
  source              = "../../azure-storage-account"
  environment         = var.environment
  application         = var.application
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  network_rule_bypass = ["AzureServices"]
  is_hns_enabled      = "true"
  storage_tier        = "Standard"
  storage_replication = "LRS"
  account_kind        = "StorageV2"
  dlg2fs              = var.dlg2fs
  tags                = local.tags
}

module "azure-synapse" {
  source                        = "../../azure-synapse"
  resource_group_name           = azurerm_resource_group.rg.name
  environment                   = var.environment
  application                   = var.application
  location                      = var.location
  storage_account_id            = module.storage.storage_id
  synapse_dlg2fs_name           = var.synapse_dlg2fs_name
  aad_admin_user                = var.aad_admin_user
  public_network_access_enabled = "true"
  sqlpools                      = var.sqlpools
  tags                          = local.tags
}
