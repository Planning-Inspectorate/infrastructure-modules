/*
    Terraform configuration file defining variable value for this environment
*/
environment = "ci"

application = "examplekvpa"

location = "northeurope"

access_policies = [
    {
     user_principal_names = ["edward.williams@hiscox.com"]
     secret_permissions   = ["Get"]
    }
]