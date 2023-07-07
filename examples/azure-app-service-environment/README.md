# azure-app-service-environment

This directory contains code that is used to deploy an App Service Environment.

## How To Use

### Default Setup

```terraform
module "ase" {
  source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules/azure-app-service-environment"
  environment = var.environment
  application = var.application
  location    = var.location
  subnet_id   = module.subnet.subnet_id
  tags        = var.tags
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
| [azurerm_app_service_environment.ase](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_environment) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [time_static.t](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_user_ip_cidrs"></a> [allowed\_user\_ip\_cidrs](#input\_allowed\_user\_ip\_cidrs) | List of CIDRs to be used for egress traffic. This should point towards a firewall or proxy, note you'll most likely need to include a route table by enabling this | `list(string)` | `null` | no |
| <a name="input_application"></a> [application](#input\_application) | Name of the application | `string` | n/a | yes |
| <a name="input_cluster_setting"></a> [cluster\_setting](#input\_cluster\_setting) | Map where keys are the name of a cluster setting and the value is the value of that particular setting | `map(string)` | <pre>{<br>  "DisableTls1.0": "1"<br>}</pre> | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name. Used as a tag and in naming the resource group | `string` | n/a | yes |
| <a name="input_front_end_scale_factor"></a> [front\_end\_scale\_factor](#input\_front\_end\_scale\_factor) | Scale factor, allowed values between 5 and 15 | `number` | `15` | no |
| <a name="input_internal_load_balancing_mode"></a> [internal\_load\_balancing\_mode](#input\_internal\_load\_balancing\_mode) | Specifies which endpoints to serve internally in the Virtual Network for the App Service Environment. Possible values are None, Web, Publishing and combined value 'Web, Publishing' | `string` | `"None"` | no |
| <a name="input_location"></a> [location](#input\_location) | The region resources will be deployed to | `string` | `"northeurope"` | no |
| <a name="input_pricing_tier"></a> [pricing\_tier](#input\_pricing\_tier) | Pricing tier, allowed vlaues are I1, I2 and I3 | `string` | `"I1"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The target resource group this module should be deployed into. If not specified one will be created for you with name like: environment-application-template-location | `string` | `""` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | ID of the subnet this ASE should be connected to. Note your subnet must be /24 or larger | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to be applied to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | Resource ID of the ASE |
| <a name="output_internal_ip_address"></a> [internal\_ip\_address](#output\_internal\_ip\_address) | IP address of the internal load balancer |
| <a name="output_outbound_ip_addresses"></a> [outbound\_ip\_addresses](#output\_outbound\_ip\_addresses) | List of outbound IP addresses |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Name of the resource group where resources have been deployed to |
| <a name="output_service_ip_address"></a> [service\_ip\_address](#output\_service\_ip\_address) | IP address of the service endpoint of the ASE |
