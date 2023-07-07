/*
    Terraform configuration file defining variable value for this environment
*/
environment              = "ci"
server_environment       = "ci"
application              = "exvmnixadeos"
vnet_resource_group_name = "devtest-itspsg-subscription-northeurope"
vnet_name                = "devtest-its-vnet-northeurope"
subnet_name              = "devtest-its-vm"
location                 = "northeurope"
business                 = "it_services"
service                  = "app"
vm_size                  = "Standard_D2s_v3"
key_vault_name           = "devtestitskvne"
key_vault_rg             = "devtest-itspsg-subscription-northeurope"
source_image_reference = {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "7-LVM"
    version   = "7.8.2020111201"
  }

