# azure-firewall-policy

This module deploys an Azure Firewall Policy. You can use this to provide a policy for a firewall or to create a policy from which other polices will inherit a baseline rule set.

Note Application rules cannot have higher priority than NAT/Network rules

Note if your rules are not valid and you attempt to attach the policy to a firewall you'll encounter an Azure InternalServerError

## How To Use

### Example

```terraform
module "fwp" {
  source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-firewall-policy"
  resource_group_name = var.vnet_rg
  environment = var.environment
  application = var.application
  location    = var.location
  tags        = var.tags
  application_rules = {
    300 = { # priority must be unique across all rules of all types
        name = "test2"
        action = "Allow"
        rules = { # map of different rules
            a_rule_name = {
                source_addresses = ["192.168.0.2"]
                source_ip_groups = []
                destination_fqdns =["mushroom.example.com"]
                destination_fqdn_tags = []
                rule_protocols = { #  map of allowed protocol keys and value port
                    Https = 443
                    Http = 80
                }
            }
        }
    }
  }
  network_rules = {
      200 = {
        name = "test3"
        action = "Deny"
        rules = {
          a_rule_name1 = {
            source_addresses = ["192.168.0.3"]
            source_ip_groups = []
            destination_addresses =["192.168.5.0"]
            destination_ip_groups = []
            destination_fqdns = []
            destination_ports = ["80", "1000-2000"]
            protocols = ["TCP", "UDP"]
          }
        }
      }
  }
  nat_rules = {
      100 = {
          name = "test4"
          action = "Dnat"
          rule_name = "example"
          rule_source_addresses = ["192.168.0.3"]
          rule_source_ip_groups = []
          rule_destination_address = "192.168.253.1"
          rule_destination_ports = ["80"]
          rule_protocols = ["TCP"]
          rule_translated_address = "192.168.20.4"
          rule_translated_port = 8443
      }
  }
```

## How To Update this README.md

* terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2, < 3 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >=0.7, < 1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 2, < 3 |
| <a name="provider_time"></a> [time](#provider\_time) | >=0.7, < 1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_firewall_policy.fwp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy) | resource |
| [azurerm_firewall_policy_rule_collection_group.fwpcg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy_rule_collection_group) | resource |
| [time_static.t](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Name of the application | `string` | n/a | yes |
| <a name="input_application_rules"></a> [application\_rules](#input\_application\_rules) | "A map of application rules where the key is the priority. Priority, name and rule names must be unique across nat, application and network rules. Format of:<br>300 = {<br>  name = "test1"<br>  action = "Deny"<br>  rules = {<br>    a\_rule\_name1 = {<br>      source\_addresses = []<br>      source\_ip\_groups = []<br>      destination\_fqdns =[]<br>      destination\_fqdn\_tags = []<br>      rule\_protocols = {<br>        Https = 443<br>      }<br>    }<br>  }<br>}<br>" | `map` | `{}` | no |
| <a name="input_base_policy_id"></a> [base\_policy\_id](#input\_base\_policy\_id) | The ID of a firewall policy which will be used as a baseline from which this policy will inherit | `string` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name. Used as a tag and in naming the resource group | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The region resources will be deployed to | `string` | `"northeurope"` | no |
| <a name="input_nat_rules"></a> [nat\_rules](#input\_nat\_rules) | "A map of nat rules where the key is the priority. Priority and name must be unique across nat, application and network rules. Note: if invalid attachment to firewall will fail. Format of:<br> 100 = {<br>   name = "test3"<br>   action = "Dnat"<br>rule\_name = "example"<br>   rule\_source\_addresses = []<br>   rule\_source\_ip\_groups = []<br>   rule\_destination\_address = "x.x.x.x"<br>   rule\_destination\_ports = []<br>   rule\_protocols = []<br>rule\_translated\_address = "x.x.x.x"<br>rule\_translated\_port = 8443<br> }<br> " | `map` | `{}` | no |
| <a name="input_network_rules"></a> [network\_rules](#input\_network\_rules) | "A map of network rules where the key is the priority. Priority, name and rule names must be unique across nat, application and network rules. Format of:<br>200 = {<br>  name = "test2"<br>  action = "Deny"<br>  rules = {<br>    a\_rule\_name2 = {<br>      source\_addresses = []<br>      source\_ip\_groups = []<br>      destination\_addresses =[]<br>      destination\_ip\_groups = []<br>destination\_fqdns = []<br>destination\_ports = []<br>      protocols = []<br>    }<br>  }<br>}<br>" | `map` | `{}` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group to deploy the Azure Firewall Policy into. Must be next to the Firewall if attached | `string` | n/a | yes |
| <a name="input_rule_collection_priority"></a> [rule\_collection\_priority](#input\_rule\_collection\_priority) | The priority of the rule collection | `number` | `500` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | The sku of the firewall policy | `string` | `"Standard"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to be applied to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_firewall_policy_id"></a> [firewall\_policy\_id](#output\_firewall\_policy\_id) | The ID of the firewall policy |
