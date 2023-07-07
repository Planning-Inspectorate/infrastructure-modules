/*
    Terraform configuration file defining variable value for this environment
*/
environment = "ci"
application = "examplewebaag"
location    = "northeurope"
sku         = {
    tier     = "Basic"
    size     = "B1"
    capacity = "1"
}
app_settings = {
  WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
  DOCKER_REGISTRY_SERVER_URL          = "https://index.docker.io"
}
site_config  = {
  app_command_line = ""
  linux_fx_version = "DOCKER|appsvcsample/python-helloworld:latest"
  always_on        = "true"
}

key_vault_name           = "devtestitskvne" 
key_vault_rg             = "devtest-itspsg-subscription-northeurope"
fqdn_url                 = "examplewebaag.azure.hiscox.com"
vnet_resource_group_name = "devtest-itspsg-subscription-northeurope"
vnet_name                = "devtest-its-vnet-northeurope"
subnet_name              = "ci-examplewebaag-subnet"
address_prefixes         = ["172.20.194.128/28"]

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
}