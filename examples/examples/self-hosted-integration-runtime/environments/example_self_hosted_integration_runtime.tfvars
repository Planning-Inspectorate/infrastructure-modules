/*
    Terraform configuration file defining variable value for this environment
*/
environment = "ci"

server_environment = "ci"

application = "shir-ex"

location = "northeurope"

business = "it_services"

service = "app"

vm_count_windows = 2

vm_size = "Standard_F4s_v2"

admin_password = "B01locK$!"

#data_factory_name = "nm-test-df"

#data_factory_resource_group_name = "nm-test-df"

subnet_name = "devtest-its-vm"

virtual_network_name = "devtest-its-vnet-northeurope"

virtual_network_resource_group_name = "devtest-itspsg-subscription-northeurope"

shir_certificate_domain = "shir-test.aks.hiscox.com"

shir_certificate_name = "cert-pfx-shir-test-aks-hiscox-com"

shir_secret_name = "cert-password-shir-test-aks-hiscox-com"

shir_key_vault_name = "devtestitskvne"

shir_key_vault_resource_group_name = "devtest-itspsg-subscription-northeurope"
