/**
* # vm-linux
* 
* An example deployment of a Linux based VM fronterd by an internal load balancer
* 
* ## How To Update this README.md
*
* terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*
* ## Diagrams
*
* ![image info](./diagrams/design.png)
*
* Unfortunately a number of tools that can parse Terraform code/statefiles and generate architetcure diagrams are limited and most are in their infancy. The built in `terraform graph` is only really useful for looking at dependencies and is too verbose to be considered a diagram on an environment.
*
* We can however turn this on its head and look at using deployed resources to produce a diagram as a stop gap. AzViz is a tool which takes one or more resource groups as input and it will parse their contents and produce a more architecture-like diagram. It will also work out the relation between different resources. Check out all its features [here](https://github.com/PrateekKumarSingh/AzViz). To use it to store a diagram post deployment:
*
* ```pwsh
* Connect-AzAccount
* Set-AzContext -Subscription 'xxxx-xxxx'
* Export-AzViz -ResourceGroup my-resource-group-1, my-rg-2 -Theme light -OutputFormat png -OutputFilePath 'diagrams/design.png' -CategoryDepth 1 -LabelVerbosity 2
* ```
*/

resource "azurerm_resource_group" "rg" {
  name     = "${var.environment}-${var.application}-nix-${var.location}"
  location = var.location
  tags     = local.tags
}

module "lb" {
  //source                   = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-load-balancer?ref=master"
  source              = "../../azure-load-balancer" // for testing example locally
  environment         = var.environment
  application         = var.application
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  frontend_ip_configuration = [{
    name                          = "frontend"
    subnet_id                     = data.azurerm_subnet.subnet.id
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


module "vm" {
  //source                   = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-vm?ref=master"
  source                                  = "../../azure-vm" // for testing example locally
  vm_count_linux                          = 1
  environment                             = var.environment
  server_environment                      = var.server_environment
  application                             = var.application
  resource_group_name                     = azurerm_resource_group.rg.name
  location                                = var.location
  business                                = var.business
  service                                 = var.service
  subnet_id                               = data.azurerm_subnet.subnet.id
  vm_size                                 = var.vm_size
  admin_password                          = sensitive(data.azurerm_key_vault_secret.admin_password.value)
  source_image_reference                  = var.source_image_reference
  disk_os_size_linux                      = var.disk_os_size_linux
  enable_backend_pool_association         = true
  load_balancer_backend_address_pools_ids = module.lb.load_balancer_backend_ids
}