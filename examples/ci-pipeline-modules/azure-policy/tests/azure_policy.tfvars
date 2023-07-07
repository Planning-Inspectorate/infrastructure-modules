/*
    Terraform configuration file defining variable value for this environment
*/

managementgroup = "its-devtest"

policy_assignment_scope = "/subscriptions/41dac0b7-f808-4ae6-94f2-010b5cc2b358"

policy_definition_name = "test-network-vnetaddressspace-its-devtest"

policy_definition_description = "Policy to define allowed network address spaces within our environments"

policy_definition_params = <<PARAMETERS
    {
    "addressPrefix": {
      "type": "Array",
      "metadata": {
        "displayName": "Allowed Address Space",
        "description": "The list of address spaces allowed."
      }
    }
  }
PARAMETERS

policy_definition_rule = <<POLICY_RULE
    {
    "if": {
      "anyOf": [
        {
          "allOf": [
            {
              "field": "type",
              "equals": "Microsoft.Network/virtualNetworks"
            },
            {
              "not": {
                "field": "Microsoft.Network/virtualNetworks/addressSpace.addressPrefixes[*]",
                "in": "[parameters('addressPrefix')]"
              }
            }
          ]
        }
      ]
    },
    "then": {
      "effect": "audit"
    }
  }
POLICY_RULE

policy_definition_metadata = <<METADATA
    {
    "category": "Network"
    }
METADATA

policy_assignment_name = "test-network-vnetaddressspace"

policy_assignment_params = <<PARAMETERS
{
  "addressPrefix": {
    "value": [ "10.0.1.0/24" ]
  }
}
PARAMETERS
