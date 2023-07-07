/**
* # kubes-cluster
*
* This will create an Azure Kubernetes Service (AKS) cluster, subnet, log analytics worksapce, NSG and Key Vault.
*
* ## How To Update this README.md
*
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: [terraform-docs](https://github.com/segmentio/terraform-docs)
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`. Alternatively setup a pre-cmmit hook to always ensure your README.md is up to date
*
* ## Diagrams
*
* ![image info](./diagrams/design.png)
*
* Unfortunately a number of tools that can parse Terraform code/statefiles and generate architetcure diagrams are limited and most are in their infancy. The built in `terraform graph` is only really useful for looking at dependencies and is too verbose to be considered a diagram on an environment.
*
* We can however turn this on its head and look at using deployed resources to produce a diagram as a stop gap. AzViz is a tool which takes one or more resource groups as input and it will parse their contents and produce a more architecture-like diagram. It will also work out the relation between different resources. Check out all its features [here](https://github.com/PrateekKumarSingh/AzViz). To use it to store a diagram post deployment:
*
* ```pwsh
* Connect-AzAccount
* Set-AzContext -Subscription 'xxxx-xxxx'
* Export-AzViz -ResourceGroup my-resource-group-1, my-rg-2 -Theme light -OutputFormat png -OutputFilePath 'diagrams/design.png' -CategoryDepth 1 -LabelVerbosity 2
* ```
*/

resource "azurerm_resource_group" "rg" {
  name     = "${var.environment}-${var.application}-kubes-${var.location}"
  location = var.location
  tags     = local.tags
}

module "subnet" {
  source                    = "../../azure-subnet"
  subnet_name               = "${var.environment}-${var.application}-aks-${var.location}"
  vnet_resource_group_name  = var.vnet_resource_group_name
  virtual_network_name      = var.virtual_network_name
  address_prefixes          = var.address_prefixes
  service_endpoints         = var.service_endpoints
  network_security_group_id = [module.nsg.network_security_group_id]
  depends_on = [
    module.nsg
  ]
}

module "nsg" {
  source              = "../../azure-network-security-group"
  resource_group_name = azurerm_resource_group.rg.name
  environment         = var.environment
  application         = var.application
  location            = var.location
  tags                = local.tags
  nsg_in_rules        = var.aks_in_rules
  nsg_out_rules       = var.aks_out_rules
}

module "keyvault" {
  source              = "../../azure-keyvault"
  resource_group_name = azurerm_resource_group.rg.name
  environment         = var.environment
  application         = var.application
  location            = var.location
  ip_rules            = var.keyvault_ip_rules
  secrets = {
    kube-config               = module.aks.kube_config,
    cluster-username          = module.aks.cluster_username,
    cluster-password          = sensitive(module.aks.cluster_password),
    cluster-client-key        = sensitive(module.aks.client_key),
    cluster-client-cert       = sensitive(module.aks.client_certificate),
    cluster-ca-cert           = module.aks.cluster_ca_certificate,
    kube-config-admin         = module.aks.kube_config_admin,
    cluster-username-admin    = module.aks.cluster_username_admin,
    cluster-password-admin    = sensitive(module.aks.cluster_password_admin),
    cluster-client-key-admin  = sensitive(module.aks.client_key_admin),
    cluster-client-cert-admin = sensitive(module.aks.client_certificate_admin),
    cluster-ca-cert-admin     = sensitive(module.aks.cluster_ca_certificate_admin)
  }
  tags = local.tags
}

module "law" {
  source              = "../../azure-log-analytics"
  resource_group_name = azurerm_resource_group.rg.name
  environment         = var.environment
  application         = var.application
  location            = var.location
}

module "aks" {
  source                     = "../../azure-kubernetes-cluster"
  resource_group_name        = azurerm_resource_group.rg.name
  environment                = var.environment
  application                = var.application
  ssh_pub_key                = var.ssh_pub_key
  log_analytics_workspace_id = module.law.workspace_id
  subnet_id                  = module.subnet.subnet_id
  tags                       = local.tags
}

resource "azurerm_role_definition" "aks_role" {
  name        = "${var.environment}-${var.application}-aks-role-${var.location}"
  scope       = data.azurerm_subscription.current.id
  description = "This role provides the least privilege permissions needed by AKS"

  permissions {
    actions = [
      "Microsoft.Compute/virtualMachines/read",
      "Microsoft.Compute/virtualMachines/write",
      "Microsoft.Compute/disks/write",
      "Microsoft.Compute/disks/read",
      "Microsoft.Network/applicationGateways/backendAddressPools/join/action",
      "Microsoft.Network/loadBalancers/write",
      "Microsoft.Network/loadBalancers/read",
      "Microsoft.Network/routeTables/read",
      "Microsoft.Network/routeTables/routes/read",
      "Microsoft.Network/routeTables/routes/write",
      "Microsoft.Network/routeTables/routes/delete",
      "Microsoft.Network/virtualNetworks/subnets/join/action",
      "Microsoft.Network/virtualNetworks/subnets/read",
      "Microsoft.Network/virtualNetworks/subnets/write",
      "Microsoft.ContainerRegistry/registries/read",
      "Microsoft.Network/publicIPAddresses/join/action",
      "Microsoft.Network/publicIPAddresses/read",
      "Microsoft.Network/publicIPAddresses/write",
    ]
  }

  assignable_scopes = [
    data.azurerm_subscription.current.id,
  ]
}

resource "azurerm_role_assignment" "cluster" {
  scope                            = data.azurerm_subscription.current.id
  role_definition_id               = split("|", azurerm_role_definition.aks_role.id)[0]
  principal_id                     = module.aks.aks_msi_id
  skip_service_principal_aad_check = true

  lifecycle {
    ignore_changes = [
      skip_service_principal_aad_check,
    ]
  }
}

####
# Kubernetes resource examples below - you should use a separate pipeline to deploy them
####

// resources to bootstrap common config into the cluster. Application deloyments should be handled in
// a seperate repo

# resource "kubernetes_namespace" "ns_core" {
#   metadata {
#     name = "core-services"
#     annotations = {
#       name = "core-services"
#     }
#   }
#   timeouts {
#     # default of 5m is too short and breaks destroy op
#     delete = "30m"
#   }
# }

// we need to pause after namespace creation. Subsequent resources should depends_on this time_sleep
# resource "time_sleep" "wait_120_seconds" {
#   depends_on = [kubernetes_namespace.ns_core]

#   create_duration = "120s"
# }

# # Deploy ingress-nginx helm chart in to the core-services namespace
# resource "helm_release" "ingress" {
#   name          = "ingress-nginx"
#   chart         = "ingress-nginx"
#   repository    = "https://kubernetes.github.io/ingress-nginx"
#   force_update  = false
#   namespace     = kubernetes_namespace.ns_core.metadata[0].name

#   values = [
#     file("nginx-values.yml")
#   ]

#   # Don't deploy ingress until the AKS maanged identity has been given rights into the subscription to join a load balancer to the subnet
#   depends_on = [null_resource.aks_msi_rbac]
# }