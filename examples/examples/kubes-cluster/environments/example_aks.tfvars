vnet_resource_group_name = "devtest-itspsg-subscription-northeurope"
virtual_network_name     = "devtest-its-vnet-northeurope"
address_prefixes         = ["172.20.194.32/28"]
environment              = "ci"

application = "exaks"

location = "northeurope"

keyvault_ip_rules = [] #["86.169.119.148/32"] // local testing

ssh_pub_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDZv0yOyhzq+XvWs+oEzMOn8OKGWncXJT8HdaI/ZoGSjP5ZrZZwg7kXsFsnrvlpX9SLqwlumPqj+YqlzayR9OML/diXZ9sjAsLEbOQiJeAr23QL9yZzVDRHcYjXvc+xJZp29JMcEM4hqfjVb8WHrsngW1E/kU17ULrGzMtJczkoA2XGG9ZEiX6SL2cVk/ZRb7R7BfLYtJUsHNr7IBwAcUGYDOz3JSQb3h6CFsQATOxzBfblHJOv1BFc7nJewHHanGaexahL0Vdz7Qe3Lu1CGXPe4fcuZxFwCFvIk+jKQFE1hMTjDDkSH+nKTKM0sFAkE0lvyaKEd0VSXBFayBadlzzt"

aks_in_rules = {
  on-prem-http = {
    access                     = "Deny"
    priority                   = 200
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "10.0.0.0/8"
    destination_port_ranges    = ["80"]
    destination_address_prefix = "*"
  }

  on-prem-https = {
    access                     = "Deny"
    priority                   = 210
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "10.0.0.0/8"
    destination_port_ranges    = ["443"]
    destination_address_prefix = "*"
  }

  azure-loadbalancer-probes = {
    access                     = "Allow"
    priority                   = 280
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "AzureLoadBalancer"
    destination_port_range     = "*"
    destination_address_prefix = "*"
  }

  intra-subnet-traffic = {
    access                     = "Allow"
    priority                   = 290
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "172.20.194.32/28" // from address_prefixes var above
    destination_port_range     = "*"
    destination_address_prefix = "*"
  }

  azure-http = {
    access                     = "Deny"
    priority                   = 300
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "172.0.0.0/8"
    destination_port_ranges    = ["80"]
    destination_address_prefix = "*"
  }

  azure-https = {
    access                     = "Deny"
    priority                   = 310
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "172.0.0.0/8"
    destination_port_ranges    = ["443"]
    destination_address_prefix = "*"
  }

  Platform-SSH = {
    access                     = "Allow"
    priority                   = 500
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "172.28.0.0/24"
    destination_port_range     = "22"
    destination_address_prefix = "*"
  }

  Kube-Dash = {
    access                     = "Deny"
    priority                   = 600
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "10.0.0.0/8"
    destination_port_range     = "9090"
    destination_address_prefix = "*"

  }

  Kube-Api = {
    access                     = "Deny"
    priority                   = 610
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "10.0.0.0/8"
    destination_port_range     = "443"
    destination_address_prefix = "*"
  }
  internal-aks-pod-traffic = {
    access                     = "Allow"
    priority                   = 1000
    protocol                   = "*"
    source_port_range          = "*"
    source_address_prefix      = "192.168.0.0/17"
    destination_port_range     = "*"
    destination_address_prefix = "192.168.0.0/17"
  }
}

aks_out_rules = {
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
