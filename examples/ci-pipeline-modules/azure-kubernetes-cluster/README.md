# azure-kubernetes-cluster

CI for Azure Kubernetes Service (AKS) cluster.

## How To Update this README.md

* terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* Follow the setup instructions here: [terraform-docs](https://github.com/segmentio/terraform-docs)
* Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`. Alternatively setup a pre-cmmit hook to always ensure your README.md is up to date

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 2 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aks"></a> [aks](#module\_aks) | ../../azure-kubernetes-cluster | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_in_rules"></a> [aks\_in\_rules](#input\_aks\_in\_rules) | A Map of inbound NSG rules | `map(any)` | `{}` | no |
| <a name="input_aks_out_rules"></a> [aks\_out\_rules](#input\_aks\_out\_rules) | A Map of outound NSG rules | `map(any)` | `{}` | no |
| <a name="input_api_server_authorized_ip_ranges"></a> [api\_server\_authorized\_ip\_ranges](#input\_api\_server\_authorized\_ip\_ranges) | Restricts access to the master API | `list(any)` | <pre>[<br>  "10.0.0.0/8",<br>  "172.0.0.0/8",<br>  "109.71.86.32/27",<br>  "109.71.86.64/27"<br>]</pre> | no |
| <a name="input_application"></a> [application](#input\_application) | Name of the application | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name. Used as a tag and in naming the resource group | `string` | n/a | yes |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Version of Kubernetes to use, if set to null the latest recommended version is used | `string` | `"1.19.7"` | no |
| <a name="input_location"></a> [location](#input\_location) | The region resources will be deployed to | `string` | `"northeurope"` | no |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | The ID of a log analytics workspace for holding container logs | `string` | n/a | yes |
| <a name="input_max_pods"></a> [max\_pods](#input\_max\_pods) | Maximum number of pods that can run on each agent | `number` | `100` | no |
| <a name="input_node_autoscale_max_count"></a> [node\_autoscale\_max\_count](#input\_node\_autoscale\_max\_count) | Maximum number of VMs in the autoscale pool | `number` | `5` | no |
| <a name="input_node_autoscale_min_count"></a> [node\_autoscale\_min\_count](#input\_node\_autoscale\_min\_count) | Minimum number of VMs in the autoscale pool | `number` | `3` | no |
| <a name="input_os_disk_size_gb"></a> [os\_disk\_size\_gb](#input\_os\_disk\_size\_gb) | Agent operating system disk size in Gb | `number` | `128` | no |
| <a name="input_rbac_admin_group_object_ids"></a> [rbac\_admin\_group\_object\_ids](#input\_rbac\_admin\_group\_object\_ids) | List of AD Group object IDs which allow contained users admin access to API | `list(string)` | `[]` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The target resource group this module should be deployed into. If not specified one will be created for you with name like: environment-application-template-location | `string` | `""` | no |
| <a name="input_ssh_pub_key"></a> [ssh\_pub\_key](#input\_ssh\_pub\_key) | Key for VM access. Never to be used | `any` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The ID of the subnet AKS will assign node IPs from | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to be applied to resources | `map(string)` | `{}` | no |
| <a name="input_vm_count"></a> [vm\_count](#input\_vm\_count) | The number of VMs in the cluster | `number` | `3` | no |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | The size of the VMs to provision | `string` | `"Standard_DS3_v2"` | no |

## Outputs

No outputs.
