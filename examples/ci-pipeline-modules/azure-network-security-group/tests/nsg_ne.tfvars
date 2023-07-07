/*
    Terraform configuration file defining variable value for this environment
*/
environment = "ci"

application = "testnsg"

location = "northeurope"

nsg_in_rules = {
    azure-https = {
        access                     = "Allow"
        priority                   = 300
        protocol                   = "Tcp"
        source_port_range          = "*"
        source_address_prefix      = "172.0.0.0/8"
        destination_port_ranges    = ["443", "8443"]
        destination_address_prefix = "*"
    }
    azure-http = {
        access                     = "Allow"
        priority                   = 310
        protocol                   = "Tcp"
        source_port_range          = "*"
        source_address_prefixes    = ["172.0.0.0/8"]
        destination_port_ranges    = ["80", "8080"]
        destination_address_prefix = "*"
    }
}
nsg_out_rules = {
    proxy = {
        access                       = "Allow"
        priority                     = 400
        protocol                     = "*"
        source_port_ranges           = ["6999", "7070"]
        source_address_prefixes      = ["172.28.0.0/25", "172.29.0.0/25"]
        destination_port_range       = "80"
        destination_address_prefixes = ["172.28.0.31"]
    }
}