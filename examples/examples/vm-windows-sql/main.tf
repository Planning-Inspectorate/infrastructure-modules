/**
* # vm-windows-sql
* 
* An example deployment of a Windows based VM using a SQL image with witness and load balancer
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
  name     = "${var.environment}-${var.application}-sqlwindows-${var.location}"
  location = var.location
  tags     = local.tags
}

resource "azurerm_resource_group" "rg_witness" {
  name     = "${var.environment}-${var.application}-sqlwitness-${var.location_witness}"
  location = var.location_witness
  tags     = local.tags
}

module "azure-storage-witness" {
  //source              = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-storage-account"
  source                                                      = "../../azure-storage-account"
  environment                                                 = "dev"
  application                                                 = "app"
  location                                                    = azurerm_resource_group.rg_witness.location
  resource_group_name                                         = azurerm_resource_group.rg_witness.name
  network_rule_virtual_network_subnet_ids_include_cicd_agents = false
}

module "lb" {
  //source              = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-load-balancer"
  source              = "../../azure-load-balancer"
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
    probe_sql = {
      port                = 59999
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
      frontend_port                  = 1433
      backend_port                   = 1433
      frontend_ip_configuration_name = "frontend"
      backend_address_pool_name      = "defaultBackend"
      probe_name                     = "probe_sql"
      enable_floating_ip             = true // required by sql clustering
      idle_timeout_in_minutes        = 4
      load_distribution              = "Default"
      disable_outbound_snat          = false
      enable_tcp_reset               = false
    }
  }
}

module "vm" {
  //source                   = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-vm?ref=master"
  source                                  = "../../azure-vm"
  vm_count_windows                        = 2
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
  enable_backend_pool_association         = true
  load_balancer_backend_address_pools_ids = module.lb.load_balancer_backend_ids
  puppet_role                             = "something_valid"
  puppetmaster_fqdn                       = "something_valid"
  tags = merge(
    local.tags,
    {
      "witness_name"                = module.azure-storage-witness.storage_name
      "witness_resource_group_name" = module.azure-storage-witness.resource_group_name
    },
  )
}