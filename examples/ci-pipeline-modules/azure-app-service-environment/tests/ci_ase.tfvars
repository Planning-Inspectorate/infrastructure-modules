/*
    Terraform configuration file defining variable value for this environment
*/
environment = "ci"

application = "ase-test"

location = "northeurope"

subnet_name              = "ci-ase"
vnet_resource_group_name = "devtest-itspsg-subscription-northeurope"
virtual_network_name     = "devtest-its-vnet-northeurope"
address_prefixes         = ["172.20.196.0/24"]
service_endpoints        = ["Microsoft.Web"]