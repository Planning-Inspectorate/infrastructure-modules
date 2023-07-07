/*
    Terraform configuration file defining variable value for this environment
*/
environment = "ci"

application = "testacr"

location    = "northeurope"

ip_rules = [
    {
        action = "Allow"
        ip_range = "1.1.1.1/32"
    },
    {
        action = "Allow"
        ip_range = "2.2.2.2/32"
    }
]

# virtual_networks = [
#     {
#         action = "Allow"
#         subnet_id = "blah"
#     }
# ]
