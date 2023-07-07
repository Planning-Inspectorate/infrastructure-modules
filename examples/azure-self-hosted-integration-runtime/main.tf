/**
* # azure-self-hosted-integration-runtime
* 
* This directory contains code that is used as to create self-hosted integration runtimes in Azure Data Factory instances.
* > NB It does *not* create a VM - this must be done separately. This is to enable this module to handle standalone/shared/linked SHIRs in a consistent fashion.
* 
* There is a simple example of calling module below, and a more detailed configuration example, showing
* how to build a shared and a linked SHIR and incorporate the VM, in the `examples/self-hosted-integration-runtime` folder.
* 
* ## How To Use
*
* Note: the role assignment uses the output of a data type to assign a role. The `module "shir"` block will require a `depends_on` listing the sources which provide the data factory name and resource group. For example:
* 
* ```terraform
* depends_on [
*   module.data_factory
* ]
* ```
*
* ```terraform
* module "shir" {
*   source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-self-hosted-integration-runtime"
*   environment = "dev"
*   application = "app"
*   location    = "northeurope"
* }
* ```
*
* ```terraform
* module "linked_shir" {
*   source                           = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-self-hosted-integration-runtime"
*   environment                      = "my-env"
*   application                      = "my-app"
*   location                         = "my-location"
*   data_factory_name                = "my-data-factory""
*   data_factory_resource_group_name = "my-data-factroy-resource-group"
*   linked_shir                      = {
*     name                             = "shared-shir-name"
*     data_factory_name                = "your-data-factory"
*     data_factory_resource_group_name = "your-data-factory-resource-group"
*   }
* }
* ``` 
* 
* See wiki page for more information: https://hiscox.atlassian.net/wiki/spaces/TPC/pages/646709562
* 
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/


resource "azurerm_role_assignment" "linked_shir" {
  count                = length(var.linked_shir) != 0 ? 1 : 0
  scope                = data.azurerm_data_factory.linked_df[0].id
  role_definition_name = "Contributor"
  principal_id         = data.azurerm_data_factory.df.identity[0].principal_id
}

resource "azurerm_data_factory_integration_runtime_self_hosted" "shir" {
  name                = var.shir_name == "" ? local.shir_name : var.shir_name
  resource_group_name = var.data_factory_resource_group_name
  data_factory_name   = var.data_factory_name

  dynamic "rbac_authorization" {
    for_each = var.linked_shir
    content {
      resource_id = data.external.linked_shir_resource_id[0].result.id
    }
  }

  depends_on = [azurerm_role_assignment.linked_shir]

}

