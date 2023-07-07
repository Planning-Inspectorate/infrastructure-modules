/*
	Terraform configuration file defining data elements
*/

resource "time_static" "t" {}

data "azurerm_subscription" "current" {}

data "azurerm_data_factory" "df" {
  name                = var.data_factory_name
  resource_group_name = var.data_factory_resource_group_name
}

data "azurerm_data_factory" "linked_df" {
  count               = length(var.linked_shir) != 0 ? 1 : 0
  name                = var.linked_shir["data_factory_name"]
  resource_group_name = var.linked_shir["data_factory_resource_group_name"]
}

data "template_file" "linked_shir_resource_id" {
  count    = length(var.linked_shir) != 0 ? 1 : 0
  template = file("${path.module}/get_shared_shir.az")
  vars = {
    name                             = var.linked_shir["name"]
    data_factory_name                = var.linked_shir["data_factory_name"]
    data_factory_resource_group_name = var.linked_shir["data_factory_resource_group_name"]
    subscription                     = data.azurerm_subscription.current.subscription_id
  }
}

data "external" "linked_shir_resource_id" {
  count = length(var.linked_shir) != 0 ? 1 : 0
  # az cli call to the get the resource id of the linked shir as no terraform data source exists
  program = ["pwsh", "-c", data.template_file.linked_shir_resource_id[0].rendered]
}