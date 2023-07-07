/*
    Terraform configuration file defining outputs
*/

output "azure_subscription" {
  description = "Name of the subscription"
  value       = data.azurerm_subscription.current.display_name
}

output "agent_auto_provisioning_setting" {
  description = "The Defender for Cloud Auto Provisioning status"
  value       = azurerm_security_center_auto_provisioning.dfc[*].auto_provision
}

output "subscription_security_contact" {
  description = "The subscription security contact"
  value       = azurerm_security_center_contact.dfc.email
}

output "mcas_setting" {
  description = "Allow Microsoft Defender for Cloud Apps to access my data?"
  value       = azurerm_security_center_setting.mcas[*].setting_name
}

output "wdatp_setting" {
  description = "Allow Microsoft Defender for Endpoint to access my data?"
  value       = azurerm_security_center_setting.wdatp[*].setting_name
}
