/**
* Terraform VM Base
* =================
* 
* Provisions all the base resources needed to stand up a Linux or Windows VM
* 
* ## Resources Created
* 
* * Network Security Group
* * Application Security Group
* * Network Interface Cards
* * Availability set
* * Diagnostics storage account (NB: Storage account default action is set to deny. If the serial console or boot diagnostics is required, temporarilly set public network access for the diagnotic storage account to 'Enabled from all networks' and revert back when finished)
* * Public IP (optional)
* 
* Soft delete will be auto enabled on the storage accounts in production environments. The retention period set for both the container and blobs is 90 days.
* 
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

data "azurerm_storage_account" "storage_account" {
  count               = var.existing_storage_account_name != "" ? 1 : 0
  name                = var.existing_storage_account_name
  resource_group_name = var.existing_storage_account_rg_name
}

resource "azurerm_network_security_group" "network_security_group" {
  count               = length(var.network_security_group_id) == 0 ? 1 : 0
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

module "central_nsg_rules" {
  count                       = length(var.network_security_group_id) == 0 ? 1 : 0
  source                      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-network-security-group-rules" # No tag to ensure latest rules are retrieved
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.network_security_group[0].name
}

resource "azurerm_public_ip" "public_ip" {
  count                        = local.public_ip_count
  name                         = "${var.name}-${format("%02d", count.index)}"
  location                     = var.location
  resource_group_name          = var.resource_group_name
  allocation_method            = var.public_ip_address_allocation
  tags                         = var.tags
}

resource "azurerm_application_security_group" "application_security_group" {
  name                = var.asg_name_override ? var.resource_group_name : var.name
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_network_interface" "network_interface" {
  count                         = var.vm_count
  name                          = "${var.name}-${format("%02d", count.index)}"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  tags                          = var.tags
  enable_accelerated_networking = var.enable_accelerated_networking
  enable_ip_forwarding          = var.enable_ip_forwarding

  ip_configuration {
    name                          = var.network_interface_ip_configuration_name == "Default" ? format("%s-%02d", var.name, count.index) : var.network_interface_ip_configuration_name
    private_ip_address_allocation = "dynamic"
    subnet_id                     = var.subnet_id

    # element() doesn't work with an empty array so use locals to construct a dummy
    public_ip_address_id = var.public_ip_address_allocation == "None" ? "" : element(local.public_ip_ids, count.index)
  }
}

resource "azurerm_network_interface_security_group_association" "nic_nsg_assoc" {
  count                     = var.vm_count
  network_interface_id      = azurerm_network_interface.network_interface[count.index].id
  network_security_group_id = length(var.network_security_group_id) > 0 ? var.network_security_group_id[0] : azurerm_network_security_group.network_security_group[0].id
}

resource "azurerm_network_interface_application_security_group_association" "nic_asg_assoc" {
  count                         = var.vm_count
  network_interface_id          = azurerm_network_interface.network_interface[count.index].id
  application_security_group_id = azurerm_application_security_group.application_security_group.id
}

resource "azurerm_network_interface_backend_address_pool_association" "backend_address_pool" {
  count                   = var.enable_backend_pool_association ? var.vm_count * length(var.load_balancer_backend_address_pools_ids) : 0
  network_interface_id    = azurerm_network_interface.network_interface[(count.index - count.index % length(var.load_balancer_backend_address_pools_ids)) / length(var.load_balancer_backend_address_pools_ids)].id
  ip_configuration_name   = azurerm_network_interface.network_interface[(count.index - count.index % length(var.load_balancer_backend_address_pools_ids)) / length(var.load_balancer_backend_address_pools_ids)].name
  backend_address_pool_id = var.load_balancer_backend_address_pools_ids[count.index % length(var.load_balancer_backend_address_pools_ids)]
}

resource "azurerm_availability_set" "availability_set" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  managed             = true
  tags                = var.tags
  platform_fault_domain_count  = var.platform_fault_domain_count
  platform_update_domain_count = var.platform_update_domain_count
}

resource "random_string" "storage_account_name" {
  count   = var.existing_storage_account_name == "" ? 1 : 0
  length  = 24
  special = false
  upper   = false
}

resource "azurerm_storage_account" "storage_account" {
  count                     = var.existing_storage_account_name == "" ? 1 : 0
  name                      = random_string.storage_account_name[0].result
  location                  = var.location
  resource_group_name       = var.resource_group_name
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = var.enable_https_traffic_only
  min_tls_version           = "TLS1_2"
  tags                      = var.tags
  allow_blob_public_access  = false

  dynamic "blob_properties" {
    for_each = local.storage_soft_delete_retention_policy == true ? toset([1]) : toset([])
    
    content {
      delete_retention_policy {
        days = 90
      }
      container_delete_retention_policy {
        days = 90
      }
    }
  }
}

resource "azurerm_storage_account_network_rules" "storage-network-rule" {
  storage_account_id         = azurerm_storage_account.storage_account[0].id
  default_action             = var.network_default_action
  ip_rules                   = var.network_rule_ips
  virtual_network_subnet_ids = var.network_rule_virtual_network_subnet_ids_include_cicd_agents ? concat(local.cicd_subnet_ids, var.network_rule_virtual_network_subnet_ids) : var.network_rule_virtual_network_subnet_ids
  bypass                     = ["AzureServices", "Logging", "Metrics"]
}
