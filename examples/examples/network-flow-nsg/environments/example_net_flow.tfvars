/*
    Terraform configuration file defining variable value for this environment
*/
environment                         = "ci"
server_environment                  = "ci"
application                         = "examplenetflow"
location                            = "northeurope"
virtual_network_name                = "devtest-its-vnet-northeurope"
virtual_network_resource_group_name = "devtest-itspsg-subscription-northeurope"
subnet_name                         = "ci-netflow-subnet"
address_prefixes                    = "172.20.195.96/28"
business                            = "it_services"
service                             = "app"
vm_size                             = "Standard_D2s_v3"
key_vault_name                      = "devtestitskvne"
key_vault_rg                        = "devtest-itspsg-subscription-northeurope"
network_watcher_name                = "NetworkWatcher_northeurope"
network_watcher_resource_group_name = "NetworkWatcherRG"
reporting_interval                  = "60"

nsg_in_rules = {
}

nsg_out_rules = {
  restricted_destination_IP = {
    access                     = "Deny"
    priority                   = 1000
    protocol                   = "*"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "*"
    destination_address_prefixes = ["216.128.128.98","23.29.115.172","37.17.224.94","185.123.60.113","21.6.128.98","185.8.128.211"]
  }
}
