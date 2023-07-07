module "server_name_linux" {
  count       = var.vm_count_linux != 0 ? 1 : 0
  source      = "./server-identification"
  environment = var.server_environment
  business    = var.business
  service     = var.service
}

module "base_linux" {
  count                                   = var.vm_count_linux != 0 ? 1 : 0
  source                                  = "./base"
  resource_group_name                     = data.azurerm_resource_group.rg.name
  name                                    = module.server_name_linux[0].name
  location                                = var.location
  load_balancer_backend_address_pools_ids = var.load_balancer_backend_address_pools_ids
  subnet_id                               = var.subnet_id
  public_ip_address_allocation            = var.public_ip_address_allocation
  vm_count                                = var.vm_count_linux
  tags                                    = local.tags
  enable_backend_pool_association         = var.enable_backend_pool_association
  network_interface_ip_configuration_name = var.network_interface_ip_configuration_name
  platform_fault_domain_count             = var.platform_fault_domain_count
  platform_update_domain_count            = var.platform_update_domain_count
  network_security_group_id               = var.network_security_group_id
  asg_name_override                       = var.asg_name_override
  existing_storage_account_name           = var.existing_storage_account_name
  existing_storage_account_rg_name        = var.existing_storage_account_rg_name
  environment                             = var.environment
  storage_soft_delete_retention_policy    = var.storage_soft_delete_retention_policy
}

module "init_linux" {
  count                          = var.vm_count_linux != 0 ? 1 : 0
  source                         = "./init"
  init_scripts                   = var.init_scripts
  custom                         = "Write-Host some extra commands"
  os_family                      = "linux"
  puppet_master                  = var.puppetmaster_fqdn
  puppet_role                    = var.puppet_role
  puppet_autosign_key            = var.puppet_autosign_key
  puppet_agent_environment       = var.puppet_agent_environment
  proxy_url                      = var.proxy_url
  dns_suffix                     = var.dns_suffix
  pe_version                     = var.pe_version
  bitbucket_team                 = var.bitbucket_team
  bitbucket_username             = var.bitbucket_username
  bitbucket_password             = var.bitbucket_password
  control_repo_name              = var.control_repo_name
  pe_console_admin_password      = var.pe_console_admin_password
  pe_console_url                 = var.pe_console_url
  pe_public_ip                   = var.pe_public_ip
  pe_webhook_label               = var.pe_webhook_label
  pe_deploy_key_label            = var.pe_deploy_key_label
  pe_puppet_role                 = var.pe_puppet_role
  pe_agent_specified_environment = var.pe_agent_specified_environment
  pe_eyaml_private_key           = var.pe_eyaml_private_key
  pe_eyaml_public_key            = var.pe_eyaml_public_key
  pe_puppetmaster_replica        = var.pe_puppetmaster_replica
}

resource "azurerm_linux_virtual_machine" "vm" {
  count                           = var.vm_count_linux
  name                            = "${module.server_name_linux[0].name}-${format("%02d", count.index)}"
  resource_group_name             = data.azurerm_resource_group.rg.name
  location                        = var.location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  network_interface_ids           = [element(module.base_linux[0].network_interface_ids, count.index)]
  availability_set_id             = module.base_linux[0].availability_set_id
  custom_data                     = base64encode(module.init_linux[0].rendered)
  provision_vm_agent              = true

  os_disk {
    name                 = "${module.server_name_linux[0].name}-${format("%02d", count.index)}-os"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = var.disk_os_size_linux
  }

  boot_diagnostics {
    storage_account_uri = module.base_linux[0].storage_uri[0]
  }

  dynamic "source_image_reference" {
    for_each = [var.source_image_reference]
    content {
      offer     = lookup(source_image_reference.value, "offer", null)
      publisher = lookup(source_image_reference.value, "publisher", null)
      sku       = lookup(source_image_reference.value, "sku", null)
      version   = lookup(source_image_reference.value, "version", null)
    }
  }

  dynamic "plan" {
    for_each = var.vm_plan_linux ? [var.source_image_reference] : []
    content {
      name      = lookup(plan.value, "sku", null)
      publisher = lookup(plan.value, "publisher", null)
      product   = lookup(plan.value, "offer", null)
    }
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      os_disk,
      custom_data,
      zone,
      provision_vm_agent,
      admin_ssh_key,
      disable_password_authentication,
      tags["patching"] # This is to allow external management of the patching tag without Terraform reverting the setting
    ]
  }

  tags = merge(
    local.tags,
    {
      "instance_count" = count.index
      "patching"       = var.patching == "auto" ? "Group${count.index % 2}" : var.patching
    },
  )
}

## Disks - warning, here be maths

# Create a list of disk names in the format 00-data-00, 00-data-01, 00-data-02,
# 01-data-00, 01-data-01, 01-data-02
# Note that this list will not be in the order shown above.
data "null_data_source" "managed_disk_name_linux" {
  count = var.vm_count_linux * var.disk_count_linux

  inputs = {
    name = "${format("%02d", count.index % var.vm_count_linux)}-data-${format(var.disk_format_suffix, floor(count.index / var.vm_count_linux))}"
  }
}

# Create a managed disk for each name in the data source. The size and sku are set using the
# modulus of the iterator by the disk_count_linux. The data source is sorted first so that if vm_count_linux
# changes the order of the list will not change. If disk_count_linux changes the order will change
# and Terraform will need to destroy and recreate disks.
resource "azurerm_managed_disk" "managed_disk_linux" {
  count = var.vm_count_linux * var.disk_count_linux
  name = "${local.linux_disk_name}-${element(
    sort(data.null_data_source.managed_disk_name_linux.*.outputs.name),
    count.index,
  )}"
  resource_group_name  = data.azurerm_resource_group.rg.name
  location             = var.location
  storage_account_type = var.disk_skus_linux[count.index % var.disk_count_linux]
  create_option        = "Empty"
  disk_size_gb         = var.disk_sizes_linux[count.index % var.disk_count_linux]
  tags                 = local.tags
  lifecycle {
    ignore_changes = [
      create_option,
      name,
      source_resource_id,
    ]
  }
}

# Attach the disks. By taking the modulus of the iterator by the disk count,
# subtracting it from the iterator and dividing the result by the disk count
# we get a sequence of virtual machine ids in the format 0,0,0,1,1,1,2,2,2
# which matches the order of the managed disk ids.
resource "azurerm_virtual_machine_data_disk_attachment" "data_disk_attachment_linux" {
  count              = var.vm_count_linux * var.disk_count_linux
  virtual_machine_id = azurerm_linux_virtual_machine.vm[(count.index - (count.index % var.disk_count_linux)) / var.disk_count_linux].id
  managed_disk_id    = azurerm_managed_disk.managed_disk_linux[count.index].id
  lun                = count.index % var.disk_count_linux
  caching            = var.disk_caching_linux[count.index % var.disk_count_linux]
  lifecycle {
    ignore_changes = [
      create_option,
      managed_disk_id,
      lun,
    ]
  }
}

# Azure Disk Encryption

resource "azurerm_virtual_machine_extension" "linux_ade_extension" {
  count                      = var.use_azure_disk_encryption == true ? var.vm_count_linux : 0
  name                       = "${azurerm_linux_virtual_machine.vm[count.index].name}-ade-extension"
  virtual_machine_id         = azurerm_linux_virtual_machine.vm[count.index].id
  publisher                  = "Microsoft.Azure.Security"
  type                       = "AzureDiskEncryptionForLinux"
  type_handler_version       = "1.1"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
          "EncryptionOperation": "EnableEncryption",
          "KeyEncryptionAlgorithm": "RSA-OAEP",
          "KeyVaultURL": "${var.ade_key_vault_uri}",
          "KeyVaultResourceId": "${var.ade_key_vault_id}",
          "VolumeType": "All"
        }
SETTINGS


  tags       = local.tags
  depends_on = [azurerm_virtual_machine_data_disk_attachment.data_disk_attachment_linux, azurerm_linux_virtual_machine.vm]
}

# Log Analytics agent

resource "azurerm_virtual_machine_extension" "linux_log_agent" {
  count                      = var.log_workspace_integration.enabled ? var.vm_count_linux : 0
  name                       = "${azurerm_linux_virtual_machine.vm[count.index].name}-oms-extension"
  virtual_machine_id         = azurerm_linux_virtual_machine.vm[count.index].id
  publisher                  = "Microsoft.EnterpriseCloud.Monitoring"
  type                       = "OmsAgentForLinux"
  type_handler_version       = "1.13"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
      "workspaceId": "${var.log_workspace_integration.workspace_id}"
    }
SETTINGS

  protected_settings = <<SETTINGS
    {
      "workspaceKey": "${var.log_workspace_integration.workspace_key}"
    }
SETTINGS

  tags = local.tags

  depends_on = [
    azurerm_linux_virtual_machine.vm
  ]
}
