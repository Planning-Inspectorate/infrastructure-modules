/*
    Terraform configuration file defining outputs
*/

output "policy_assignment_id" {
  description = "ID of policy assignment"
  value       = azurerm_policy_assignment.policyassignment.id
}

output "policy_definition_id" {
  description = "ID of policy definition"
  value       = azurerm_policy_definition.policydefinition.id
}