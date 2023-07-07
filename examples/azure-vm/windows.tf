module "server_name_windows" {
  count       = var.vm_count_windows != 0 ? 1 : 0
  source      = "./server-identification"
  environment = var.server_environment
  business    = var.business
  service     = var.service
}

module "base_windows" {
  count                                   = var.vm_count_windows != 0 ? 1 : 0
  source                                  = "./base"
  resource_group_name                     = data.azurerm_resource_group.rg.name
  name                                    = module.server_name_windows[0].name
  location                                = var.location
  load_balancer_backend_address_pools_ids = var.load_balancer_backend_address_pools_ids
  subnet_id                               = var.subnet_id
  public_ip_address_allocation            = var.public_ip_address_allocation
  vm_count                                = var.vm_count_windows
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

module "init_windows" {
  count                              = var.vm_count_windows != 0 ? 1 : 0
  source                             = "./init"
  init_scripts                       = var.init_scripts
  custom                             = "Write-Host some extra commands"
  os_family                          = "windows"
  puppet_master                      = var.puppetmaster_fqdn
  puppet_role                        = var.puppet_role
  puppet_autosign_key                = var.puppet_autosign_key
  puppet_agent_environment           = var.puppet_agent_environment
  puppet_agent_url                   = var.puppet_agent_url
  proxy_url                          = var.proxy_url
  dns_suffix                         = var.dns_suffix
  data_disk                          = var.data_disk
  shir_auth_key                      = var.shir_auth_key
  shir_certificate_domain            = var.shir_certificate_domain
  shir_certificate_name              = var.shir_certificate_name
  shir_secret_name                   = var.shir_secret_name
  shir_key_vault_name                = var.shir_key_vault_name
  shir_key_vault_resource_group_name = var.shir_key_vault_resource_group_name
  waf_ip_addresses                   = var.waf_ip_addresses
  waf_license_keys                   = var.waf_license_keys
  waf_sku                            = var.waf_sku
  waf_password                       = var.waf_password
  waf_cluster_secret                 = var.waf_cluster_secret
}

resource "azurerm_windows_virtual_machine" "win" {
  count                      = var.vm_count_windows
  name                       = "${module.server_name_windows[0].name}-${format("%02d", count.index)}"
  resource_group_name        = data.azurerm_resource_group.rg.name
  location                   = var.location
  size                       = var.vm_size
  admin_username             = var.admin_username
  admin_password             = var.admin_password
  network_interface_ids      = [element(module.base_windows[0].network_interface_ids, count.index)]
  availability_set_id        = module.base_windows[0].availability_set_id
  custom_data                = base64encode(module.init_windows[0].rendered)
  enable_automatic_updates   = false
  patch_mode                 = "Manual"
  provision_vm_agent         = true
  license_type               = "Windows_Server"
  encryption_at_host_enabled = var.encryption_at_host_enabled

  os_disk {
    name                 = "${module.server_name_windows[0].name}-${format("%02d", count.index)}-os"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = var.disk_os_size_windows
  }

  boot_diagnostics {
    storage_account_uri = module.base_windows[0].storage_uri[0]
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

  additional_unattend_content {
    setting = "AutoLogon"
    content = "<AutoLogon><Password><Value>${var.admin_password}</Value></Password><Enabled>true</Enabled><LogonCount>1</LogonCount><Username>${var.admin_username}</Username></AutoLogon>"
  }
  additional_unattend_content {
    setting = "FirstLogonCommands"
    content = "<FirstLogonCommands><SynchronousCommand><CommandLine>cmd /c \"copy C:\\AzureData\\CustomData.bin C:\\Config.ps1\"</CommandLine><Description>copy</Description><Order>1</Order></SynchronousCommand><SynchronousCommand><CommandLine>%windir%\\System32\\WindowsPowerShell\\v1.0\\powershell.exe -NoProfile -ExecutionPolicy Bypass -file C:\\Config.ps1</CommandLine><Description>script</Description><Order>2</Order></SynchronousCommand></FirstLogonCommands>"
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      os_disk,
      additional_unattend_content[0],
      additional_unattend_content[1],
      custom_data,
      zone,
      provision_vm_agent,
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
# 01-data-00, 01-data-01, 01-data-02 by using the modulus of the iterator by the
# vm_count_windows and the disk_count_windows. Note that this list will not be in the order shown above.
data "null_data_source" "managed_disk_name_windows" {
  count = var.vm_count_windows * var.disk_count_windows

  inputs = {
    name = "${format("%02d", count.index % var.vm_count_windows)}-data-${format(var.disk_format_suffix, floor(count.index / var.vm_count_windows))}"
  }
}

# Create a managed disk for each name in the data source. The size and sku are set using the
# modulus of the iterator by the disk_count_windows. The data source is sorted first so that if vm_count_windows
# changes the order of the list will not change. If disk_count_windows changes the order will change
# and Terraform will need to destroy and recreate disks.
resource "azurerm_managed_disk" "managed_disk_windows" {
  count = var.vm_count_windows * var.disk_count_windows
  name = "${local.windows_disk_name}-${element(
    sort(data.null_data_source.managed_disk_name_windows.*.outputs.name),
    count.index,
  )}"
  resource_group_name  = data.azurerm_resource_group.rg.name
  location             = var.location
  storage_account_type = var.disk_skus_windows[count.index % var.disk_count_windows]
  create_option        = "Empty"
  disk_size_gb         = var.disk_sizes_windows[count.index % var.disk_count_windows]
  tags                 = local.tags
  lifecycle {
    ignore_changes = [
      create_option,
      name,
      source_resource_id,
      hyper_v_generation,
    ]
  }
}

# Attach the disks. By taking the modulus of the iterator by the disk count,
# subtracting it from the iterator and dividing the result by the disk count
# we get a sequence of virtual machine ids in the format 0,0,0,1,1,1,2,2,2
# which matches the order of the managed disk ids.
resource "azurerm_virtual_machine_data_disk_attachment" "data_disk_attachment_windows" {
  count              = var.vm_count_windows * var.disk_count_windows
  virtual_machine_id = azurerm_windows_virtual_machine.win[(count.index - (count.index % var.disk_count_windows)) / var.disk_count_windows].id
  managed_disk_id    = azurerm_managed_disk.managed_disk_windows[count.index].id
  lun                = count.index % var.disk_count_windows
  caching            = var.disk_caching_windows[count.index % var.disk_count_windows]
  lifecycle {
    ignore_changes = [
      create_option,
      managed_disk_id,
      lun,
    ]
  }
}

# Log Analytics agent

resource "azurerm_virtual_machine_extension" "windows_log_agent" {
  count                      = var.log_workspace_integration.enabled ? var.vm_count_windows : 0
  name                       = "${azurerm_windows_virtual_machine.win[count.index].name}-oms-extension"
  virtual_machine_id         = azurerm_windows_virtual_machine.win[count.index].id
  publisher                  = "Microsoft.EnterpriseCloud.Monitoring"
  type                       = "MicrosoftMonitoringAgent"
  type_handler_version       = "1.0"
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
    azurerm_windows_virtual_machine.win
  ]
}