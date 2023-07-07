# azure-kubernetes-cluster

This will create an Azure Kubernetes Service (AKS) cluster.

## How To Use

### Default cluster

```terraform
module "aks" {
  source                     = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-kubernetes-cluster"
  resource_group_name        = azurerm_resource_group.rg.name
  environment                = var.environment
  application                = var.application
  ssh_pub_key                = var.ssh_pub_key
  log_analytics_workspace_id = module.law.workspace_id
  subnet_id                  = module.subnet.subnet_id
  tags                       = local.tags
}
```

## Networking

We deploy clusters into Azure subnets in order to prevent a native cluster from overlapping the on-prem `10.x.x.x` range. We also use `kubenet` network policy instead of `azure`. This means that a cluster assigns IP addresses to pods and services from within its own virtual network, specifically the `192.168.0.0/16` range, while the underlying nodes are assigned IPs from the Azure subnet. Each node then requires a /24 netmask which is used for pod IP allocation from the `192.168.0.0/16` vnet. The default node quota in AKS is 100 so if you need to use all 100 you will require 25,000 available addresses. To handle this we assign the range `192.168.0.0/17` to the `pod_cidr` which makes 32,768 address avaiable. We then assign the other half of the vnet, `192.168.128.0/17` to the `service_cidr` so that kubernetes services can be allocated IPs. In reality giving the services a pool of 32,768 address is way too many but given that the 100 node quota is satisfied it keeps the netmasking simple to just split the entire vnet down the middle.

The `azure` policy uses the local subnet which the cluster is deployed into not only for node IP allocation but also for pod IP allocation, requiring a very large Azure subnet to handle cluster growth but also upgrades. This can very easily be exhuasted and it also exposes individual pods on the vnet requiring an extra layer of security to keep it locked down to an ingress controller.

## RBAC AAD Integration

Azure AD authentication is provided to AKS clusters with OpenID Connect. OpenID Connect is an identity layer built on top of the OAuth 2.0 protocol. From inside of the Kubernetes cluster Webhook Token Authentication is used to verify authentication tokens.

To configure this AKS auto-creates a pair of service principals known as the Server Application and Client Application. Previous to the August 2020 AKS release we had to create these ourselves and supply them to the code. The below is the historical README of what this involved.

Server Application

* This account is responsible for retrieving a users AAD group membership. It has access to read directory data and delegates permissions to sign-in and read user profiles and directory membership. It is considered best practice to use this account accross multiple clusters for easier management and auditing. It is currently set by a default in variables.tf through its ID, the friendly name is AKSServerApplication.

This app registration has been setup in advance and is called: AKSServerApplication

The process involed in creating it followed:

* New Azure AD application called: AKSServerApplication
 * Config settings:
   * Supported account types: 'Accounts in this organizational directory only'
   * Web redirect URI type: 'https://aksserverapplication'
 * Hit 'Register'
* Select the manifest of the App Registration and edit the 'groupMembershipClaims' value to: 'all'
* Select 'Certificates & Secrets' pane and generate a new key ÔÇô I need the secret value so I can encrypt it for the automation
* Select 'API Permissions' pane and:
 * Under Microsoft APIs select 'Microsoft Graph'
   * Select 'Delegated Permissions' and check the 'Directory.Read.All' permission
   * Select 'Delegated Permissions' and check the 'User.Read' permission
   * Select 'Application Permissions' and check the 'Directory.Read.All' permission
 * Select Add permissions and then 'Grant consent'
* Under the 'Expose API' pane of the App Registration select 'Add a scope'
 * Config:
   * Scope name: AKSServerApplication
   * Admin consent display name: AKSServerApplication
   * Admin consent description: Server application for AKS RBAC integration
   * Ensure 'State' => 'Enabled'
 * Save it with 'Add scope'

### Updating the Server Application Secret

The Server Application makes use of a secret with an expiry time of one year. To update this secret across clusters you can either update it with the existing secret which effectively just extends the expiry time. To rotate it instead you can run the Az Cli:

```bash
az aks update-credentials \
    --resource-group myResourceGroup \
    --name myAKSCluster \
    --reset-service-principal \
    --service-principal $SP_ID \
    --client-secret $SP_SECRET
```

Client Application

* The client uses the delegated permissions of the Server Application to post user tokens for verification to AAD. It is reccomended to use a different Client Application for each cluster and to not use the same ID as the Server Application. If a user wishes to login they first must retrieve a Kubernetes configuration with the Azure Cli which verifies if they have the correct Azure RBAC permissions. Once done if they run any kubectl command they are prompted to visit the Azure device logon page which in turn calls the Secure Token Service associated with our AAD Tenant and the Client through the Server App will verify if your user or a group you are a member of has access to the cluster. Tokens expire after 60 minutes.
* These typically follow the naming convention `${enviroment}${businessUnit}AKSClientApplication` and are set in environment, note for Production + DR we append a shortented location indicator, ie. ProdPSGAKSClientApplicationNE.

The general process flow follows:
* New Azure AD Application called: ${enviroment}${businessUnit}AKSClientApplication
  * Config settings:
    * Supported account types: 'Accounts in this organizational directory only'
    * Web redirect URI type: `https://${enviroment}${businessUnit}AKSClientApplication`
  * Hit 'Register'
* Select 'API Permissions' pane and add:
  * Select 'My APIs' and choose the Server Application called: AKSServerApplication
    * Select 'Delegated Permissions' and check box next to AKSServerApplication
  * Select Add permissions and then 'Grant consent'
* Select the 'Authentication' pane under the App Registration
  * Under 'Default client type' select 'yes' to treat as public client

These two accounts are required in advance of standing up an AKS cluster.

[Further reading](https://docs.microsoft.com/en-us/azure/aks/aad-integration).

## Cluster Service Principal for Accessing Azure Resources

A cluster needs to be able to dynamically provision storage, load balancers and access networks. Historically we used terraform to create this service principal with the following permissions, this is know baked into AKS itself:

```bash
"Microsoft.Compute/virtualMachines/read",
"Microsoft.Compute/virtualMachines/write",
"Microsoft.Compute/disks/write",
"Microsoft.Compute/disks/read",
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
```

## Log Analytics

Clusters make use of a Log Analytics workspace to receive container logs, service logs, kube events, pod/node inventories and insight metrics. Example queries can be found in the ADO wiki.

## Availability Zones

The cluster is deployed across three availability zones for increased resiliency.

## Firewalling

When hosting applications that need some sort of ingress you must either have an in-cluster firewall (like modsecurity) or an external Barracuda/App Gateway etc.

## Cluster Access

Each namspace is bootstrapped with `read` and `admin` roles corresponding to groups in AD. The groups have the naming convention `${var.environment}-${var.application}-${namespace}-aks-role-[read/admin]`. This is to provide emergency write access and pod read access to users.

The built in cluster-admin role is associated to AD using the group naming convention `${var.environment}-${var.application}-aks-cluster-admin`. This grants cluster-wide admin privileges.

NB: when creating a Kubernetes role binding which uses an AD group you cannot use the group name, you must use its object ID. You can build clusters without having the groups in place, the roles will just not work. Once you have the groups and associated IDs you can rerun terraform using IDs and it'll update the groups in place.

# Suggested Add-Ons when Deploying your own Cluster

## Nginx-Ingress

Nginx is a webserver/loadbalancer which acts as the entry point to the cluster. It is deployed through a helm chart and configured to spool up an Azure loadbalancer with an internal IP address. It runs as a daemon which watches the api `/ingresses` endpoint across all namespaces and configures rules accordingly.

Helm deployments which require client connections should include an Ingress resource type which defines the FQDN of the application, a service to indicate where incoming traffic should be directed to, any resource paths and annotations to utilise services such as certs.

## Kubernetes Key Vault Integration

Prior to Kubernetes 1.16 we we're usuing the [Key Vault FlexVolume](https://github.com/Azure/kubernetes-keyvault-flexvol) module. All new clusters are now using version 1.16+ so in order to access Key Vault secrets from pods the suggested method is to use the [Secrets Store CSI Driver](https://github.com/Azure/secrets-store-csi-driver-provider-azure).

In principal it uses a custom resource (see the driver repo on how ot do this) to define the type of access (VMSS identity, pod identity etc.), the required Key Vault instance and the names of secrets.

The secrets can then be used in pod deployments through volume mounts using the CSI driver, e.g:

```yaml
volumes:
    - name: secrets-store-inline
      csi:
        driver: secrets-store.csi.k8s.io
        readOnly: true
        volumeAttributes:
          secretProviderClass: "azure-kvname"
```

The secret name(s) specified in the custom resource are then exposed as an accessible mount, cat-ing something like `/mnt/secrets-store/secret1` will give you the value of `secret1`.

# AKS Security - Additional Considerations

Azure Kubernetes Service is compliant with Security Operations Center (SOC), International Organization for Standardization (ISO), Payment Card Data Security Standard (PCI DSS), and Health Insurance Portability and Accountability Act (HIPAA).

The underlying hosts use AppArmor by default which restricts read, write, execute and system functions.

## CIS Kubernetes Benchmark Version 1.4.0

The configuration of this cluster has been graded against the Center for Internet Security standards defined by these configuration profiles:

Level 1 - these items intend to:

* be practical and prudent;
* provide a clear security benefit; and
* not inhibit the utility of the technology beyond acceptable means.

Level 2 - extends the 'Level 1' profile. Items in this profile exhibit one or more of the following characteristics:

* are intended for environments or use cases where security is paramount
* acts as defense in depth measure
* may negatively inhibit the utility or performance of the technology

As of 2019.06.18 our clusters meet: XXXX

The following table indicates the passes and failures for each criterion.

| Catagory | Type | Item | Pass | Comment |
|----------|------|:-----|:----:|:--------|
| 1 Master Node Security Configuration | 1.1 API Server | 1.1.1 Ensure that the --anonymous-auth argument is set to false (Not Scored) | TRUE |  |
|  |  | 1.1.2 Ensure that the --basic-auth-file argument is not set (Scored) | TRUE |  |
|  |  | 1.1.3 Ensure that the --insecure-allow-any-token argument is not set (Scored) | TRUE |  |
|  |  | 1.1.4 Ensure that the --kubelet-https argument is set to true (Scored) | TRUE |  |
|  |  | 1.1.5 Ensure that the --insecure-bind-address argument is not set (Scored) | TRUE |  |
|  |  | 1.1.6 Ensure that the --insecure-port argument is set to 0 (Scored) |  |  |
|  |  | 1.1.7 Ensure that the --secure-port argument is not set to 0 (Scored) |  |  |
|  |  | 1.1.8 Ensure that the --profiling argument is set to false (Scored) |  |  |
|  |  | 1.1.9 Ensure that the --repair-malformed-updates argument is set to false (Scored) |  |  |
|  |  | 1.1.10 Ensure that the admission control plugin AlwaysAdmit is not set (Scored) |  |  |
|  |  | 1.1.11 Ensure that the admission control plugin AlwaysPullImages is set (Scored) |  |  |
|  |  | 1.1.12 Ensure that the admission control plugin DenyEscalatingExec is set (Scored) |  |  |
|  |  | 1.1.13 Ensure that the admission control plugin SecurityContextDeny is set (Not Scored) |  |  |
|  |  | 1.1.14 Ensure that the admission control plugin NamespaceLifecycle is set (Scored) |  |  |
|  |  | 1.1.15 Ensure that the --audit-log-path argument is set as appropriate (Scored) |  |  |
|  |  | 1.1.16 Ensure that the --audit-log-maxage argument is set to 30 or as appropriate (Scored) |  |  |
|  |  | 1.1.17 Ensure that the --audit-log-maxbackup argument is set to 10 or as appropriate (Scored) |  |  |
|  |  | 1.1.18 Ensure that the --audit-log-maxsize argument is set to 100 or as appropriate (Scored) |  |  |
|  |  | 1.1.19 Ensure that the --authorization-mode argument is not set to AlwaysAllow (Scored) |  |  |
|  |  | 1.1.20 Ensure that the --token-auth-file parameter is not set (Scored) |  |
|  |  | 1.1.21 Ensure that the --kubelet-certificate-authority argument is set as appropriate (Scored) |  |  |
|  |  | 1.1.22 Ensure that the --kubelet-client-certificate and --kubelet-client-key arguments are set as appropriate (Scored) |  |  |
|  |  | 1.1.23 Ensure that the --service-account-lookup argument is set to true (Scored) |  |  |
|  |  | 1.1.24 Ensure that the admission control plugin PodSecurityPolicy is set (Scored) |  |  |
|  |  | 1.1.25 Ensure that the --service-account-key-file argument is set as appropriate (Scored) |  |  |
|  |  | 1.1.26 Ensure that the --etcd-certfile and --etcd-keyfile arguments are set as appropriate (Scored) |  |  |
|  |  | 1.1.27 Ensure that the admission control plugin ServiceAccount is set (Scored) |  |  |
|  |  | 1.1.28 Ensure that the --tls-cert-file and --tls-private-key-file arguments are set as appropriate (Scored) |  |  |
|  |  | 1.1.29 Ensure that the --client-ca-file argument is set as appropriate (Scored) |  |  |
|  |  | 1.1.30 Ensure that the API Server only makes use of Strong Cryptographic Ciphers (Not Scored) |  |  |
|  |  | 1.1.31 Ensure that the --etcd-cafile argument is set as appropriate (Scored) |  |  |
|  |  | 1.1.32 Ensure that the --authorization-mode argument includes Node (Scored) |  |  |
|  |  | 1.1.33 Ensure that the admission control plugin NodeRestriction is set (Scored) |  |  |
|  |  | 1.1.34 Ensure that the --experimental-encryption-provider-config argument is set as appropriate (Scored) |  |  |
|  |  | 1.1.35 Ensure that the encryption provider is set to aescbc (Scored) |  |  |
|  |  | 1.1.36 Ensure that the admission control plugin EventRateLimit is set (Scored) |  |  |
|  |  | 1.1.37 Ensure that the AdvancedAuditing argument is not set to false (Scored) |  |  |
|  |  | 1.1.38 Ensure that the --request-timeout argument is set as appropriate (Scored) |  |  |
|  |  | 1.1.39 Ensure that the --authorization-mode argument includes RBAC (Scored) |  |  |
|  | 1.2 Scheduler | 1.2.1 Ensure that the --profiling argument is set to false (Scored) |  |  |
|  |  | 1.2.2 Ensure that the --address argument is set to 127.0.0.1 (Scored) |  |  |
|  | 1.3 Controller Manager | 1.3.1 Ensure that the --terminated-pod-gc-threshold argument is set as appropriate (Scored) |  |  |
|  |  | 1.3.2 Ensure that the --profiling argument is set to false (Scored) |  |  |
|  |  | 1.3.3 Ensure that the --use-service-account-credentials argument is set to true (Scored) |  |  |
|  |  | 1.3.4 Ensure that the --service-account-private-key-file argument is set as appropriate (Scored) |  |  |
|  |  | 1.3.5 Ensure that the --root-ca-file argument is set as appropriate (Scored) |  |  |
|  |  | 1.3.6 Ensure that the RotateKubeletServerCertificate argument is set to true (Scored) |  |  |
|  |  | 1.3.7 Ensure that the --address argument is set to 127.0.0.1 (Scored) |  |  |
|  | 1.4 Configuration Files | 1.4.1 Ensure that the API server pod specification file permissions are set to 644 or more restrictive (Scored) |  |  |
|  |  | 1.4.2 Ensure that the API server pod specification file ownership is set to root:root (Scored) |  |  |
|  |  | 1.4.3 Ensure that the controller manager pod specification file permissions are set to 644 or more restrictive (Scored) |  |  |
|  |  | 1.4.4 Ensure that the controller manager pod specification file ownership is set to root:root (Scored) |  |  |
|  |  | 1.4.5 Ensure that the scheduler pod specification file permissions are set to 644 or more restrictive (Scored) |  |  |
|  |  | 1.4.6 Ensure that the scheduler pod specification file ownership is set to root:root (Scored) |  |  |
|  |  | 1.4.7 Ensure that the etcd pod specification file permissions are set to 644 or more restrictive (Scored) |  |  |
|  |  | 1.4.8 Ensure that the etcd pod specification file ownership is set to root:root (Scored) |  |  |
|  |  | 1.4.9 Ensure that the Container Network Interface file permissions are set to 644 or more restrictive (Not Scored) |  |  |
|  |  | 1.4.10 Ensure that the Container Network Interface file ownership is set to root:root (Not Scored) |  |  |
|  |  | 1.4.11 Ensure that the etcd data directory permissions are set to 700 or more restrictive (Scored) |  |  |
|  |  | 1.4.12 Ensure that the etcd data directory ownership is set to etcd:etcd (Scored) |  |  |
|  |  | 1.4.13 Ensure that the admin.conf file permissions are set to 644 or more restrictive (Scored) |  |  |
|  |  | 1.4.14 Ensure that the admin.conf file ownership is set to root:root (Scored) |  |  |
|  |  | 1.4.15 Ensure that the scheduler.conf file permissions are set to 644 or more restrictive (Scored) |  |  |
|  |  | 1.4.16 Ensure that the scheduler.conf file ownership is set to root:root (Scored) |  |  |
|  |  | 1.4.17 Ensure that the controller-manager.conf file permissions are set to 644 or more restrictive (Scored) |  |  |
|  |  | 1.4.18 Ensure that the controller-manager.conf file ownership is set to root:root (Scored) |  |  |
|  |  | 1.4.19 Ensure that the Kubernetes PKI directory and file ownership is set to root:root (Scored) |  |  |
|  |  | 1.4.20 Ensure that the Kubernetes PKI certificate file permissions are set to 644 or more restrictive (Scored) |  |  |
|  |  | 1.4.21 Ensure that the Kubernetes PKI key file permissions are set to 600 (Scored) |  |  |
|  | 1.5 etcd | 1.5.1 Ensure that the --cert-file and --key-file arguments are set as appropriate (Scored) |  |  |
|  |  | 1.5.2 Ensure that the --client-cert-auth argument is set to true (Scored) |  |  |
|  |  | 1.5.3 Ensure that the --auto-tls argument is not set to true (Scored) |  |  |
|  |  | 1.5.4 Ensure that the --peer-cert-file and --peer-key-file arguments are set as appropriate (Scored) |  |  |
|  |  | 1.5.5 Ensure that the --peer-client-cert-auth argument is set to true (Scored) |  |  |
|  |  | 1.5.6 Ensure that the --peer-auto-tls argument is not set to true (Scored) |  |  |
|  |  | 1.5.7 Ensure that a unique Certificate Authority is used for etcd (Not Scored) |  |  |
|  | 1.6 General Security Primitives | 1.6.1 Ensure that the cluster-admin role is only used where required (Not Scored) |  |  |
|  |  | 1.6.2 Create administrative boundaries between resources using namespaces (Not Scored) |  |  |
|  |  | 1.6.3 Create network segmentation using Network Policies (Not Scored) |  |  |
|  |  | 1.6.4 Ensure that the seccomp profile is set to docker/default in your pod definitions (Not Scored) |  |  |
|  |  | 1.6.5 Apply Security Context to Your Pods and Containers (Not Scored) |  |  |
|  |  | 1.6.6 Configure Image Provenance using ImagePolicyWebhook admission controller (Not Scored) |  |  |
|  |  | 1.6.7 Configure Network policies as appropriate (Not Scored) |  |  |
|  |  | 1.6.8 Place compensating controls in the form of PSP and RBAC for privileged containers usage (Not Scored) |  |  |
|  | 1.7 PodSecurityPolicies | 1.7.1 Do not admit privileged containers (Not Scored) |  |  |
|  |  | 1.7.2 Do not admit containers wishing to share the host process ID namespace (Scored) |  |  |
|  |  | 1.7.3 Do not admit containers wishing to share the host IPC namespace (Scored) |  |  |
|  |  | 1.7.4 Do not admit containers wishing to share the host network namespace (Scored) |  |  |
|  |  | 1.7.5 Do not admit containers with allowPrivilegeEscalation (Scored) |  |  |
|  |  | 1.7.6 Do not admit root containers (Not Scored) |  |  |
|  |  | 1.7.7 Do not admit containers with dangerous capabilities (Not Scored) |  |  |
| 2 Worker Node Security Configuration | 2.1 Kubelet | 2.1.1 Ensure that the --anonymous-auth argument is set to false (Scored) | TRUE |  |
|  |  | 2.1.2 Ensure that the --authorization-mode argument is not set to AlwaysAllow (Scored) | TRUE |  |
|  |  | 2.1.3 Ensure that the --client-ca-file argument is set as appropriate (Scored) | TRUE |  |
|  |  | 2.1.4 Ensure that the --read-only-port argument is set to 0 (Scored) | FALSE | By default set to 10255/TCP, need to find a way of checking |
|  |  | 2.1.5 Ensure that the --streaming-connection-idle-timeout argument is not set to 0 (Scored) | TRUE | Set to 5m |
|  |  | 2.1.6 Ensure that the --protect-kernel-defaults argument is set to true (Scored) | FALSE | By default not set |
|  |  | 2.1.7 Ensure that the --make-iptables-util-chains argument is set to true (Scored) | TRUE | Defaults to True |
|  |  | 2.1.8 Ensure that the --hostname-override argument is not set (Scored) | TRUE |  |
|  |  | 2.1.9 Ensure that the --event-qps argument is set to 0 (Scored) | TRUE |  |
|  |  | 2.1.10 Ensure that the --tls-cert-file and --tls-private-key-file arguments are set as appropriate (Scored) | FALSE | By default a self-signed cert and key are generated and used for kubelet https |
|  |  | 2.1.11 Ensure that the --cadvisor-port argument is set to 0 (Scored) | TRUE | Default |
|  |  | 2.1.12 Ensure that the --rotate-certificates argument is not set to false (Scored) | TRUE |  |
|  |  | 2.1.13 Ensure that the RotateKubeletServerCertificate argument is set to true (Scored) | FALSE | RotateKubeletServerCertificate causes the kubelet to both request a serving certificate after bootstrapping its client credentials and rotate the certificate as its existing credentials expire. This automated periodic rotation ensures that the there are no downtimes due to expired certificates and thus addressing availability in the CIA security triad. Note: This recommendation only applies if you let kubelets get their certificates from the API server. In case your kubelet certificates come from an outside authority/tool (e.g. Vault) then you need to take care of rotation yourself |
|  |  | 2.1.14 Ensure that the Kubelet only makes use of Strong Cryptographic Ciphers (Not Scored) | FALSE |  |
|  | 2.2 Configuration Files | 2.2.1 Ensure that the kubelet.conf file permissions are set to 644 or more restrictive (Scored) | TRUE |  |
|  |  | 2.2.2 Ensure that the kubelet.conf file ownership is set to root:root (Scored) | TRUE |  |
|  |  | 2.2.3 Ensure that the kubelet service file permissions are set to 644 or more restrictive (Scored) | TRUE |  |
|  |  | 2.2.4 Ensure that the kubelet service file ownership is set to root:root (Scored) | TRUE |  |
|  |  | 2.2.5 Ensure that the proxy kubeconfig file permissions are set to 644 or more restrictive (Scored) |  | No config file found |
|  |  | 2.2.6 Ensure that the proxy kubeconfig file ownership is set to root:root (Scored) |  | No config file found |
|  |  | 2.2.7 Ensure that the certificate authorities file permissions are set to 644 or more restrictive (Scored) | TRUE |  |
|  |  | 2.2.8 Ensure that the client certificate authorities file ownership is set to root:root (Scored) | TRUE |  |
|  |  | 2.2.9 Ensure that the kubelet configuration file ownership is set to root:root (Scored) | TRUE |  |
|  |  | 2.2.10 Ensure that the kubelet configuration file has permissions set to 644 or more restrictive (Scored) | TRUE |  |

## How To Update this README.md

* terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* Follow the setup instructions here: [terraform-docs](https://github.com/segmentio/terraform-docs)
* Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`. Alternatively setup a pre-cmmit hook to always ensure your README.md is up to date

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2, < 3 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >=0.7, < 1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 2, < 3 |
| <a name="provider_time"></a> [time](#provider\_time) | >=0.7, < 1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_kubernetes_cluster.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [time_static.t](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_server_authorized_ip_ranges"></a> [api\_server\_authorized\_ip\_ranges](#input\_api\_server\_authorized\_ip\_ranges) | Restricts access to the master API | `list(string)` | <pre>[<br>  "10.0.0.0/8",<br>  "172.0.0.0/8",<br>  "109.71.86.32/27",<br>  "109.71.86.64/27"<br>]</pre> | no |
| <a name="input_application"></a> [application](#input\_application) | Name of the application | `string` | n/a | yes |
| <a name="input_auto_scaler_profile"></a> [auto\_scaler\_profile](#input\_auto\_scaler\_profile) | Cluster scaling behaviour | <pre>object({<br>    balance_similar_node_groups      = bool<br>    expander                         = string<br>    max_graceful_termination_sec     = number<br>    max_node_provisioning_time       = string<br>    max_unready_nodes                = number<br>    max_unready_percentage           = number<br>    new_pod_scale_up_delay           = string<br>    scale_down_delay_after_add       = string<br>    scale_down_delay_after_delete    = string<br>    scale_down_delay_after_failure   = string<br>    scan_interval                    = string<br>    scale_down_unneeded              = string<br>    scale_down_unready               = string<br>    scale_down_utilization_threshold = string<br>    skip_nodes_with_local_storage    = bool<br>    skip_nodes_with_system_pods      = bool<br>  })</pre> | <pre>{<br>  "balance_similar_node_groups": false,<br>  "expander": "random",<br>  "max_graceful_termination_sec": 600,<br>  "max_node_provisioning_time": "15m",<br>  "max_unready_nodes": 3,<br>  "max_unready_percentage": 45,<br>  "new_pod_scale_up_delay": "10s",<br>  "scale_down_delay_after_add": "10m",<br>  "scale_down_delay_after_delete": "10s",<br>  "scale_down_delay_after_failure": "3m",<br>  "scale_down_unneeded": "10m",<br>  "scale_down_unready": "20m",<br>  "scale_down_utilization_threshold": "0.5",<br>  "scan_interval": "10s",<br>  "skip_nodes_with_local_storage": true,<br>  "skip_nodes_with_system_pods": true<br>}</pre> | no |
| <a name="input_automatic_channel_upgrade"></a> [automatic\_channel\_upgrade](#input\_automatic\_channel\_upgrade) | Automatic upgrades of Kubernetes version. Possible values are 'patch', 'stable', 'rapid' and 'node-image'. We suggest 'patch' as that will only upgrade minor versions as opposed to 'stable' which upgrades major versions and could break API stability | `string` | `"patch"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name. Used as a tag and in naming the resource group | `string` | n/a | yes |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Version of Kubernetes to use, if set to null the latest recommended version is used | `string` | `"1.21.7"` | no |
| <a name="input_location"></a> [location](#input\_location) | The region resources will be deployed to | `string` | `"northeurope"` | no |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | The ID of a log analytics workspace for holding container logs | `string` | n/a | yes |
| <a name="input_maintenance_allowed"></a> [maintenance\_allowed](#input\_maintenance\_allowed) | The day and available hours which a mainitenance window will be in place thereby permitting automatic patching | <pre>object({<br>    day   = string<br>    hours = list(string)<br>  })</pre> | <pre>{<br>  "day": "Sunday",<br>  "hours": [<br>    "20",<br>    "21",<br>    "22",<br>    "23"<br>  ]<br>}</pre> | no |
| <a name="input_max_pods"></a> [max\_pods](#input\_max\_pods) | Maximum number of pods that can run on each agent | `number` | `100` | no |
| <a name="input_node_autoscale_max_count"></a> [node\_autoscale\_max\_count](#input\_node\_autoscale\_max\_count) | Maximum number of VMs in the autoscale pool | `number` | `5` | no |
| <a name="input_node_autoscale_min_count"></a> [node\_autoscale\_min\_count](#input\_node\_autoscale\_min\_count) | Minimum number of VMs in the autoscale pool | `number` | `3` | no |
| <a name="input_os_disk_size_gb"></a> [os\_disk\_size\_gb](#input\_os\_disk\_size\_gb) | Agent operating system disk size in Gb | `number` | `128` | no |
| <a name="input_rbac_admin_group_object_ids"></a> [rbac\_admin\_group\_object\_ids](#input\_rbac\_admin\_group\_object\_ids) | List of AD Group object IDs which allow contained users admin access to API | `list(string)` | `[]` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The target resource group this module should be deployed into. If not specified one will be created for you with name like: environment-application-template-location | `string` | `""` | no |
| <a name="input_ssh_pub_key"></a> [ssh\_pub\_key](#input\_ssh\_pub\_key) | Key for VM access. Never to be used | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The ID of the subnet AKS will assign node IPs from | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to be applied to resources | `map(string)` | `{}` | no |
| <a name="input_vm_count"></a> [vm\_count](#input\_vm\_count) | The number of VMs in the cluster | `number` | `3` | no |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | The size of the VMs to provision | `string` | `"Standard_DS3_v2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aks_id"></a> [aks\_id](#output\_aks\_id) | Name of the Azure Kubernetes Service |
| <a name="output_aks_msi_id"></a> [aks\_msi\_id](#output\_aks\_msi\_id) | ID of the AKS MSI |
| <a name="output_client_certificate"></a> [client\_certificate](#output\_client\_certificate) | Public certificate used by clients to authenticate the cluster, base64 encoded |
| <a name="output_client_certificate_admin"></a> [client\_certificate\_admin](#output\_client\_certificate\_admin) | Admin public certificate used by clients to authenticate the cluster, base64 encoded |
| <a name="output_client_key"></a> [client\_key](#output\_client\_key) | Private key required to authenticate to the cluster, base64 encoded |
| <a name="output_client_key_admin"></a> [client\_key\_admin](#output\_client\_key\_admin) | Admin private key required to authenticate to the cluster, base64 encoded |
| <a name="output_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#output\_cluster\_ca\_certificate) | CA certificate used as root of trust for the cluster, base64 encoded |
| <a name="output_cluster_ca_certificate_admin"></a> [cluster\_ca\_certificate\_admin](#output\_cluster\_ca\_certificate\_admin) | Admin CA certificate used as root of trust for the cluster, base64 encoded |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Name of the Azure Kubernetes Service |
| <a name="output_cluster_password"></a> [cluster\_password](#output\_cluster\_password) | Password required to administer cluster |
| <a name="output_cluster_password_admin"></a> [cluster\_password\_admin](#output\_cluster\_password\_admin) | Admin password required to administer cluster |
| <a name="output_cluster_username"></a> [cluster\_username](#output\_cluster\_username) | Username required to administer cluster |
| <a name="output_cluster_username_admin"></a> [cluster\_username\_admin](#output\_cluster\_username\_admin) | Admin username required to administer cluster |
| <a name="output_fqdn"></a> [fqdn](#output\_fqdn) | Service fqdn used for remote configuration |
| <a name="output_host"></a> [host](#output\_host) | Service host used for remote configuration |
| <a name="output_kube_config"></a> [kube\_config](#output\_kube\_config) | Config block from azurerm\_kubernetes\_cluster |
| <a name="output_kube_config_admin"></a> [kube\_config\_admin](#output\_kube\_config\_admin) | Admin config block from azurerm\_kubernetes\_cluster |
| <a name="output_node_rg_name"></a> [node\_rg\_name](#output\_node\_rg\_name) | Name of the node resource group |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Name of the resource group where resources have been deployed to |
