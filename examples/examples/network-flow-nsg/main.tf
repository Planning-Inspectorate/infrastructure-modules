/*
* # network-flow-nsg
* 
* An example of applying the network flow nsg logs to a sample vm/subnet to capture traffic. 
*
* Note: This example includes a separate rule base that lists all the BUs current VNET ranges. 
* 
* This will need to be updated with any new VNETS added by any BUs, but does incldue a Hiscox catch-all group
*
* ## How To Update this README.md
*
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*
* ## Diagrams
*
* ![image info](./diagrams/design.png)
*/

resource "azurerm_resource_group" "resource_group" {
  name     = "${var.environment}-${var.application}-netflow-${var.location}"
  location = var.location
  tags     = local.tags
}

module "nsg" {
  source              = "../../azure-network-security-group" # Local reference due to changes to NSG module
  environment         = var.environment
  application         = var.application
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  nsg_in_rules        = var.nsg_in_rules
  nsg_out_rules       = var.nsg_out_rules
  tags                = local.tags
}

resource "azurerm_network_security_rule" "nsg_rule_permit_lb_vms_ssh" {
  name                                       = "permit_lb_vms_ssh"
  priority                                   = 200
  direction                                  = "Inbound"
  access                                     = "Allow"
  protocol                                   = "Tcp"
  source_port_range                          = "*"
  destination_port_range                     = "22"
  source_address_prefix                      = "AzureLoadBalancer"
  destination_application_security_group_ids = module.vm.application_security_group_id_linux
  resource_group_name                        = azurerm_resource_group.resource_group.name
  network_security_group_name                = module.nsg.network_security_group_name
}

module "subnet" {
  source                    = "../../azure-subnet"
  subnet_name               = var.subnet_name
  vnet_resource_group_name  = var.virtual_network_resource_group_name
  virtual_network_name      = var.virtual_network_name
  address_prefixes          = [var.address_prefixes]
  network_security_group_id = [module.nsg.network_security_group_id]
  service_endpoints         = ["Microsoft.Storage"]
}

module "storage" {
  source                                  = "../../azure-storage-account"
  resource_group_name                     = azurerm_resource_group.resource_group.name
  environment                             = var.environment
  application                             = var.application
  location                                = var.location
  network_rule_virtual_network_subnet_ids = [module.subnet.subnet_id]
  network_rule_bypass                     = ["AzureServices"]
  tags                                    = local.tags
}

module "law" {
  source              = "../../azure-log-analytics"
  resource_group_name = azurerm_resource_group.resource_group.name
  environment         = var.environment
  application         = var.application
  location            = var.location
  tags                = local.tags
}

module "flow_log" {
  source                                      = "../../azure-network-watcher-flow-log"
  environment                                 = var.environment
  application                                 = var.application
  location                                    = var.location
  tags                                        = local.tags
  flow_log_name                               = join("-", [var.environment, var.application, "flow-log"])
  network_watcher_name                        = var.network_watcher_name
  network_watcher_resource_group_name         = var.network_watcher_resource_group_name
  log_analytics_workspace_resource_group_name = module.law.resource_group_name
  log_analytics_workspace_name                = module.law.workspace_name
  network_security_group_id                   = module.nsg.network_security_group_id
  storage_account_id                          = module.storage.storage_id
  reporting_interval                          = var.reporting_interval
  analytics                                   = var.analytics

  depends_on = [
    module.law
  ]
}

module "lb-int" {
  source              = "../../azure-load-balancer"
  environment         = var.environment
  application         = var.application
  resource_group_name = azurerm_resource_group.resource_group.name
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
      port                = 22
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
      frontend_port                  = 443
      backend_port                   = 22
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
  source                                  = "../../azure-vm"
  vm_count_linux                          = 1
  environment                             = var.environment
  server_environment                      = var.server_environment
  application                             = var.application
  resource_group_name                     = azurerm_resource_group.resource_group.name
  network_security_group_id               = [module.nsg.network_security_group_id]
  location                                = var.location
  business                                = var.business
  service                                 = var.service
  subnet_id                               = module.subnet.subnet_id
  vm_size                                 = var.vm_size
  admin_password                          = sensitive(data.azurerm_key_vault_secret.admin_password.value)
  source_image_reference                  = var.source_image_reference
  disk_os_size_linux                      = var.disk_os_size_linux
  enable_backend_pool_association         = true
  load_balancer_backend_address_pools_ids = module.lb-int.load_balancer_backend_ids
}
