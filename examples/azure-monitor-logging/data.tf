/*
	Terraform configuration file defining data elements
*/

data "azurerm_monitor_diagnostic_categories" "catagories" {
  resource_id = var.target_resource_id
}