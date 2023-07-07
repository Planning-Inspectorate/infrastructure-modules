/*
    Terraform configuration file defining provider configuration
*/
locals {

  logging_catagories = setsubtract(data.azurerm_monitor_diagnostic_categories.catagories.logs, var.exclude_logging_catagories)

  metric_catagories = setsubtract(data.azurerm_monitor_diagnostic_categories.catagories.metrics, var.exclude_metric_catagories)

}
