/*
    Terraform configuration file defining variable value for this environment
*/
environment = "ci"
application = "aagexample"
vnet_resource_group_name = "devtest-itspsg-subscription-northeurope"
vnet_name = "devtest-its-vnet-northeurope"
subnet_name = "ci-exampleaag-subnet"
address_prefixes = ["172.20.194.16/28"]
location = "northeurope"
nsg_in_rules = {
    azure-infrastructure-communication = {
        access                      = "Allow"
        priority                    = 150
        protocol                    = "Tcp"
        source_port_range           = "*"
        source_address_prefix       = "GatewayManager"
        destination_port_range      = "65200-65535"
        destination_address_prefix  = "*"
    }
    azure-load-balancer = {
        access                      = "Allow"
        priority                    = 160
        protocol                    = "Tcp"
        source_port_range           = "*"
        source_address_prefix       = "AzureLoadBalancer"
        destination_port_range      = "*"
        destination_address_prefix  = "*"
    }
    azure-vnet = {
        access                      = "Allow"
        priority                    = 170
        protocol                    = "Tcp"
        source_port_range           = "*"
        source_address_prefix       = "VirtualNetwork"
        destination_port_range      = "*"
        destination_address_prefix  = "*"
    }
}
nsg_out_rules = {
    # all-out = {
    #     access                     = "Allow"
    #     priority                    = 1000
    #     protocol                    = "*"
    #     source_port_range           = "*"
    #     source_address_prefix       = "*"
    #     destination_port_range      = "*"
    #     destination_address_prefix  = "*"
    # }
    # vnet-vnet-out = {
    #     access                     = "Allow"
    #     priority                    = 1100
    #     protocol                    = "*"
    #     source_port_range           = "*"
    #     source_address_prefix       = "VirtualNetwork"
    #     destination_port_range      = "*"
    #     destination_address_prefix  = "VirtualNetwork"
    # }
}

