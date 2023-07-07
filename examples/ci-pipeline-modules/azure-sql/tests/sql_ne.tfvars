location    = "northeurope"
environment = "ci"

tags = {
  schedule = "none"
}

allow_subnet_ids = {
  devtest_vm_subnet_ne = "/subscriptions/41dac0b7-f808-4ae6-94f2-010b5cc2b358/resourceGroups/devtest-itspsg-subscription-northeurope/providers/Microsoft.Network/virtualNetworks/devtest-its-vnet-northeurope/subnets/devtest-its-vm"
}