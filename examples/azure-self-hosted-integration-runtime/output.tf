/*
    Terraform configuration file defining outputs
*/

output "shir_id" {
  value = azurerm_data_factory_integration_runtime_self_hosted.shir.id
}

output "shir_name" {
  value = azurerm_data_factory_integration_runtime_self_hosted.shir.name
}

output "shir_auth_keys" {
  value = [
    azurerm_data_factory_integration_runtime_self_hosted.shir.auth_key_1,
    azurerm_data_factory_integration_runtime_self_hosted.shir.auth_key_2
  ]
}
