/*
    Terraform configuration file defining outputs
*/

output "resource_group_name" {
  description = "Name of the resource group where resources have been deployed to"
  value       = data.azurerm_resource_group.rg.name
}

output "name" {
  description = "The value of the `name` variable."
  value       = local.name
}

output "network_interface_ids_linux" {
  value       = module.base_linux[*].network_interface_ids
  description = "List of NIC resource IDs."
}

output "network_interface_ips_linux" {
  value       = module.base_linux[*].network_interface_ips
  description = "List of NIC IP addresses."
}

output "virtual_machine_base_name_linux" {
  value       = module.server_name_linux[*].name
  description = "Generated base VM name. Single element list."
}

output "virtual_machine_names_linux" {
  value       = azurerm_linux_virtual_machine.vm[*].name
  description = "List of VM names."
}

output "principal_ids_linux" {
  value       = azurerm_linux_virtual_machine.vm[*].identity.0.principal_id
  description = "List of VM MSI service principal IDs."
}

output "tenant_ids_linux" {
  value       = azurerm_linux_virtual_machine.vm[*].identity.0.tenant_id
  description = "List of VM MSI service tenbant IDs."
}

output "virtual_machine_ids_linux" {
  value       = azurerm_linux_virtual_machine.vm[*].id
  description = "List of VM IDs."
}

output "network_security_group_name_linux" {
  value       = module.base_linux[*].network_security_group_name
  description = "Name of the NSG associated to the NICs. Single element list."
}

output "network_security_group_id_linux" {
  value       = module.base_linux[*].network_security_group_id
  description = "Resource ID of the NSG associated to the NICs. Single element list."
}

output "public_ip_names_linux" {
  value       = module.base_linux[*].public_ip_names
  description = "List of Public IP Address names associated to the NICs."
}

output "public_ip_ids_linux" {
  value       = module.base_linux[*].public_ip_ids
  description = "List of Public IP Address resource IDs associated to the NICs."
}

output "application_security_group_id_linux" {
  value       = module.base_linux[*].application_security_group_id
  description = "Resource ID of the ASG Associated to the NICs. Single element list."
}

output "storage_id_linux" {
  value       = module.base_linux[*].storage_id
  description = "The ID of the Storage Account. Single element list."
}

output "storage_name_linux" {
  value       = module.base_linux[*].storage_name
  description = "The name of the storage account. Single element list."
}

output "storage_uri_linux" {
  value       = module.base_linux[*].storage_uri
  description = "The endpoint URL for blob storage in the primary location. Single element list."
}

output "network_interface_ids_windows" {
  value       = module.base_windows[*].network_interface_ids
  description = "List of NIC resource IDs."
}

output "network_interface_ips_windows" {
  value       = module.base_windows[*].network_interface_ips
  description = "List of NIC IP addresses."
}

output "virtual_machine_base_name_windows" {
  value       = module.server_name_windows[*].name
  description = "Generated base VM name. Single element list."
}

output "virtual_machine_names_windows" {
  value       = azurerm_windows_virtual_machine.win[*].name
  description = "List of VM names."
}

output "principal_ids_windows" {
  value       = azurerm_windows_virtual_machine.win[*].identity.0.principal_id
  description = "List of VM MSI service principal IDs."
}

output "tenant_ids_windows" {
  value       = azurerm_windows_virtual_machine.win[*].identity.0.tenant_id
  description = "List of VM MSI service tenant IDs."
}

output "virtual_machine_ids_windows" {
  value       = azurerm_windows_virtual_machine.win[*].id
  description = "List of VM IDs."
}

output "network_security_group_name_windows" {
  value       = module.base_windows[*].network_security_group_name
  description = "Name of the NSG associated to the NICs. Single element list."
}

output "network_security_group_id_windows" {
  value       = module.base_windows[*].network_security_group_id
  description = "Resource ID of the NSG associated to the NICs. Single element list."
}

output "public_ip_names_windows" {
  value       = module.base_windows[*].public_ip_names
  description = "List of Public IP Address names associated to the NICs."
}

output "public_ip_ids_windows" {
  value       = module.base_windows[*].public_ip_ids
  description = "List of Public IP Address resource IDs associated to the NICs."
}

output "application_security_group_id_windows" {
  value       = module.base_windows[*].application_security_group_id
  description = "Resource ID of the ASG Associated to the NICs. Single element list."
}

output "storage_id_windows" {
  value       = module.base_windows[*].storage_id
  description = "The ID of the Storage Account. Single element list."
}

output "storage_name_windows" {
  value       = module.base_windows[*].storage_name
  description = "The name of the storage account. Single element list."
}

output "storage_uri_windows" {
  value       = module.base_windows[*].storage_uri
  description = "The endpoint URL for blob storage in the primary location. Single element list."
}

output "windows_machine_metadata" {
  value = [ for k, v in azurerm_windows_virtual_machine.win : {
      hostname = v.name
      id = v.id
      nic = v.network_interface_ids,
      disk_ids = concat(
        tolist(["${data.azurerm_resource_group.rg.id}/providers/Microsoft.Compute/disks/${v.os_disk[0].name}"]),
        [for s in azurerm_virtual_machine_data_disk_attachment.data_disk_attachment_windows : s.managed_disk_id if s.virtual_machine_id == v.id]
      )
    }
  ]
  description = "List containing metadata about Windows VMs. Useful to loop over when multiple pieces of data are needed in the loop."
  depends_on = [
    azurerm_windows_virtual_machine.win
  ]
}

output "linux_machine_metadata" {
  value = [ for k, v in azurerm_linux_virtual_machine.vm : {
      hostname = v.name
      id = v.id
      nic = v.network_interface_ids,
      disk_ids = concat(
        tolist(["${data.azurerm_resource_group.rg.id}/providers/Microsoft.Compute/disks/${v.os_disk[0].name}"]),
        [for s in azurerm_virtual_machine_data_disk_attachment.data_disk_attachment_linux : s.managed_disk_id if s.virtual_machine_id == v.id]
      )
    }
  ]
  description = "List containing metadata about Linux VMs. Useful to loop over when multiple pieces of data are needed in the loop."
  depends_on = [
    azurerm_linux_virtual_machine.vm
  ]
}