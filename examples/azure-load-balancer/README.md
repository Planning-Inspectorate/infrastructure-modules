# azure-load-balancer

Creates a load balancer with rules

## How To Use

### Load Balancer with probe, backend and rule

```terraform
module "lb" {
  source              = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-load-balancer"
  environment         = var.environment
  application         = var.application
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  frontend_ip_configuration = [{
    name                          = "frontend"
    subnet_id                     = module.subnet.subnet_id
    private_ip_address            = null
    private_ip_address_allocation = "Dynamic"
    private_ip_address_version    = "IPv4"
    public_ip_address_id          = null
    public_ip_prefix_id           = null
    zones                         = null
  }]
  probes = {
    probe_name = {
      port                = 8080
      protocol            = "Tcp"
      request_path        = null
      interval_in_seconds = 5
      number_of_probes    = 2
    }
  }
  backend_pool_names = [
    "defaultBackend"
  ]
  load_balancer_rules = {
    rule1_name = {
      protocol                       = "Tcp"
      frontend_port                  = 80
      backend_port                   = 8080
      frontend_ip_configuration_name = "frontend"
      backend_address_pool_name      = "defaultBackend"
      probe_name                     = "probe_name"
      enable_floating_ip             = false
      idle_timeout_in_minutes        = 4
      load_distribution              = "Default"
      disable_outbound_snat          = false
      enable_tcp_reset               = false
    }
  }
}
```

A single backend\_pool\_names will result in load\_balancer\_rules.backend\_address\_pool\_name being overridden with the single vale.
Set it to "" when defining your load\_balancer\_rules if you don't want to provide explicitly

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
| [azurerm_lb.lb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb) | resource |
| [azurerm_lb_backend_address_pool.backend](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_backend_address_pool) | resource |
| [azurerm_lb_probe.probe](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_probe) | resource |
| [azurerm_lb_rule.rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_rule) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [time_static.t](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Name of the application | `string` | n/a | yes |
| <a name="input_backend_pool_names"></a> [backend\_pool\_names](#input\_backend\_pool\_names) | List of names for the backend pools | `list(string)` | `[]` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name. Used as a tag and in naming the resource group | `string` | n/a | yes |
| <a name="input_frontend_ip_configuration"></a> [frontend\_ip\_configuration](#input\_frontend\_ip\_configuration) | "For example:<br>frontend\_ip\_configuration = [{<br>  name                          = "frontend"<br>  subnet\_id                     = module.subnet.subnet\_id<br>  private\_ip\_address            = null<br>  private\_ip\_address\_allocation = "Dynamic"<br>  private\_ip\_address\_version    = "IPv4"<br>  public\_ip\_address\_id          = null<br>  public\_ip\_prefix\_id           = null<br>  zones                         = null<br>}]" | <pre>list(object({<br>    name                          = string<br>    subnet_id                     = string<br>    private_ip_address            = string<br>    private_ip_address_allocation = string<br>    private_ip_address_version    = string<br>    public_ip_address_id          = string<br>    public_ip_prefix_id           = string<br>    zones                         = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_load_balancer_rules"></a> [load\_balancer\_rules](#input\_load\_balancer\_rules) | "List of rules, can only be set if a frontend configuration has been set. The map key is the name of the rule. For Example:<br>  load\_balancer\_rules = {<br>    name1 = {<br>      protocol                       = "Tcp"<br>      frontend\_port                  = 80<br>      backend\_port                   = 8080<br>      frontend\_ip\_configuration\_name = "frontend"<br>      backend\_address\_pool\_name      = "defaultBackend"<br>      probe\_name                     = "probe1"<br>      enable\_floating\_ip             = false<br>      idle\_timeout\_in\_minutes        = 4<br>      load\_distribution              = "Default"<br>      disable\_outbound\_snat          = false<br>      enable\_tcp\_reset               = false<br>}}" | <pre>map(object({<br>    protocol                       = string<br>    frontend_port                  = number<br>    backend_port                   = number<br>    frontend_ip_configuration_name = string<br>    backend_address_pool_name      = string<br>    probe_name                     = string<br>    enable_floating_ip             = bool<br>    idle_timeout_in_minutes        = number<br>    load_distribution              = string<br>    disable_outbound_snat          = bool<br>    enable_tcp_reset               = bool<br>  }))</pre> | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | The region resources will be deployed to | `string` | `"northeurope"` | no |
| <a name="input_name"></a> [name](#input\_name) | The name to associate with load balancer instead of default '<env>-<application>-lb-<location>' scheme | `string` | `""` | no |
| <a name="input_probes"></a> [probes](#input\_probes) | "List of probes, can only be set if a frontend configuration has been set. The map key is the name of the probe. For Example:<br>  probes = {<br>    probe1 = {<br>      port = 22<br>      protocol = "Tcp"<br>      request\_path = null<br>      interval\_in\_seconds = 5<br>      number\_of\_probes = 2<br>}}" | <pre>map(object({<br>    port                = number<br>    protocol            = string<br>    request_path        = string<br>    interval_in_seconds = number<br>    number_of_probes    = number<br>  }))</pre> | `{}` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The target resource group this module should be deployed into. If not specified one will be created for you with name like: environment-application-template-location | `string` | `""` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | The LB sku to use. Defaults to 'Standard' | `string` | `"Standard"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to be applied to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_frontend_ip_configurations"></a> [frontend\_ip\_configurations](#output\_frontend\_ip\_configurations) | All frontend configurations |
| <a name="output_load_balancer_backend_ids"></a> [load\_balancer\_backend\_ids](#output\_load\_balancer\_backend\_ids) | Takes the map of backend data and extracts the IDs into a list |
| <a name="output_load_balancer_id"></a> [load\_balancer\_id](#output\_load\_balancer\_id) | ID of the load balancer |
| <a name="output_load_balancer_name"></a> [load\_balancer\_name](#output\_load\_balancer\_name) | Name of the load balancer |
| <a name="output_private_ip_address"></a> [private\_ip\_address](#output\_private\_ip\_address) | Private ip address of the load balancer |
| <a name="output_probe_data"></a> [probe\_data](#output\_probe\_data) | Map probe configuration |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Name of the resource group where resources have been deployed to |
