/*
    Terraform configuration file defining variable value for this environment
*/
environment = "ci"

application = "tfrt"

location = "northeurope"

routes = [
  {
    name                   = "internet"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "Internet"
    next_hop_in_ip_address = "null"
  }
]