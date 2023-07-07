/**
* # azure-sql-managed-instance
* 
* This creates a managed SQL instance and should be invoked as a sub-module like:
* 
* ```terraform
* module "sql_managed" {
*   source = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azuresql-managed"
*   ...
*   _other required params_
*   ...
* }
* ```
*
* It requires a subnet with appropriate service delegation, Network Security Group and Route Table
* to deploy the Managed Instance into.
* 
*
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: [terraform-docs](https://github.com/segmentio/terraform-docs)
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

// if you do not specify an existing resurce group one will be created for you,
// when supplying the resource group name to a resource declaration you should use
// the data type i.e 'data.azurerm_resource_group.rg.name'
resource "azurerm_resource_group" "rg" {
  count    = var.resource_group_name == "" ? 1 : 0
  name     = "${var.environment}-${var.application}-sqlmi-${var.location}"
  location = var.location
  tags     = local.tags
}

resource "azurerm_template_deployment" "sqlmi" {
  name                = data.azurerm_resource_group.rg.name
  resource_group_name = data.azurerm_resource_group.rg.name

  parameters = {
    "administratorLogin"         = "${var.environment}${var.application}_SQLAdmin"
    "administratorLoginPassword" = var.sql_password
    "location"                   = var.location
    "managedInstanceName"        = data.azurerm_resource_group.rg.name
    "subnetId"                   = data.azurerm_subnet.subnet.id
    "skuName"                    = var.sku_name
    "skuEdition"                 = var.sku_edition
    "storageSizeInGB"            = var.storage_size
    "vCores"                     = var.cores
    "licenseType"                = var.license
    "hardwareFamily"             = var.hardware_family
    #TODO: Figure out a way to pass the tags into the ARM template
    "tags" = jsonencode(local.tags)
  }

  template_body   = file("${path.module}/sqlmanaged.json")
  deployment_mode = "Incremental"
}

