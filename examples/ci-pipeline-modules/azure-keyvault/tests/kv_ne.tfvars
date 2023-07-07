environment = "ci"
location    = "northeurope"
ip_rules    = ["81.152.71.58"]

subnet_ids  = ["/subscriptions/bab9ed05-2c6e-4631-a0cf-7373c33838cc/resourceGroups/ExpressRoute-RG-TC1-01/providers/Microsoft.Network/virtualNetworks/Core-VN-01/subnets/VM-SN-01"]

access_policies = [
    {
     user_principal_names = []
     secret_permissions   = []
    },
    {
     group_names        = []
     secret_permissions = []
    },
]

secrets = {
  the-secret = "A secret stored in the vault",
  another-secret = "Another secret stored in the vault"
}