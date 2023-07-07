subnet_name              = "ci-pipeline"
vnet_resource_group_name = "devtest-itspsg-subscription-northeurope"
virtual_network_name     = "devtest-its-vnet-northeurope"
address_prefixes         = ["172.20.194.96/28"]
service_endpoints        = ["Microsoft.Sql"]