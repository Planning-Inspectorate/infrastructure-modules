/*
    Terraform configuration file defining variable value for this environment
*/
environment = "ci"

application = "examplelas"

location = "westeurope"

vnet_resource_group_name = "devtest-itspsg-subscription-westeurope"
virtual_network_name = "devtest-its-vnet-westeurope"
address_prefixes_outbound = ["172.21.195.0/28"]
law_resource_group_name = "devtest-itspsg-subscription-westeurope"
law_name = "devtest-its-logworkspace-westeurope"