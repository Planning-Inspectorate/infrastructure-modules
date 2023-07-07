/**
* # azure-databricks
*
* Provisions a Azure Databricks Service (Workspace and Cluster)
* 
* ## How To Use
*
* * Inputs should be refereced in a module to create your Databricks Workspace and Cluster of the sort: `module "azure_databricks" {...}`
*
* ```HCL
* 
* module "azure_databricks" {
*  source                   = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-databricks"
*  environment              = var.environment
*  application              = var.application
*  location                 = var.location
*  sku                      = var.sku
*  spark_version            = var.spark_version
*  node_type_id             = var.node_type_id
*  autotermination_minutes  = var.autotermination_minutes
*  autoscale                = var.autoscale
*  databricks_admin_users   = ["user1@example.com", "user2@example.com"]
*  tags                     = var.tags
* }
* ```
* 
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and * output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

// if you do not specify an existing resurce group one will be created for you,
// when supplying the resource group name to a resource declaration you should use
// the data type i.e 'data.azurerm_resource_group.rg.name'
resource "azurerm_resource_group" "rg" {
  count    = var.resource_group_name == "" ? 1 : 0
  name     = "${var.environment}-${var.application}-databricks-${var.location}"
  location = var.location
  tags     = local.tags
}

resource "azurerm_databricks_workspace" "azurerm_databricks_workspace" {
  name                = var.databricks_workspace_name == "" ? local.databricks_workspace_name : var.databricks_workspace_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location
  sku                 = var.sku

  dynamic "custom_parameters" {
    for_each = length(var.custom_parameters) == 0 ? [] : tolist([var.custom_parameters])
    content {
      public_subnet_name  = custom_parameters.value.public_subnet_name
      private_subnet_name = custom_parameters.value.private_subnet_name
      virtual_network_id  = custom_parameters.value.id
    }
  }

  tags = var.tags
}

resource "databricks_cluster" "databricks_cluster" {
  cluster_name            = var.databricks_cluster_name == "" ? local.databricks_cluster_name : var.databricks_cluster_name
  spark_version           = var.spark_version
  node_type_id            = var.node_type_id
  autotermination_minutes = var.autotermination_minutes

  num_workers = var.num_workers
  is_pinned   = var.is_pinned

  dynamic "autoscale" {
    for_each = var.autoscale == null ? [] : tolist([var.autoscale])
    content {
      min_workers = autoscale.value.autoscale_min_workers
      max_workers = autoscale.value.autoscale_max_workers
    }
  }

  dynamic "library" {
    for_each = toset(var.python_libraries)
    content {
      pypi {
        package = library.value
      }
    }
  }

  spark_conf = var.spark_conf
  depends_on = [azurerm_databricks_workspace.azurerm_databricks_workspace]
}

resource "databricks_user" "databricks_admin_users" {
  for_each = toset(var.databricks_admin_users)

  user_name            = each.key
  allow_cluster_create = true
  depends_on           = [azurerm_databricks_workspace.azurerm_databricks_workspace]
}

data "databricks_group" "databricks_admins_group" {
  display_name = "admins"
  depends_on   = [azurerm_databricks_workspace.azurerm_databricks_workspace]
}

resource "databricks_group_member" "group_member_admin_users" {
  for_each = toset(var.databricks_admin_users)

  group_id   = data.databricks_group.databricks_admins_group.id
  member_id  = databricks_user.databricks_admin_users[each.key].id
  depends_on = [azurerm_databricks_workspace.azurerm_databricks_workspace]
}