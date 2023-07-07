/**
* # azure-role-assignment
* 
* Provisions required RBAC role assignments on resource groups in Azure. 
* 
* Resource groups can already exist or be created dynamically by the module.
* If the resource groups already exist, you must still supply values for location and tags - simply set these to "null", however.
* This is due to a limitation in Terraform's definition of custom object types at present.
*
* ## Dependencies
*
* ## Resources
*
* * Optionally, Azure resource group(s) if specified
* * Azure RBAC Role Assignments as defined in tfvars
*
* ## Example
* 
* The following provides an example of the call to this module, including the necessary variable definitions with example default values.
* 
* ```terraform
* variable "resource_groups" {
*    default = ["existing-resource-group"]
* }
* 
* variable "assignments" {
*     default = [
*         {
*             role = "owner"
*             user = "admin.user@domain.com"
*         },
*         {
*             role = "reader"
*             group = "Normal users"
*         },
*         {
*             role = "contributor"
*             id = "xxxxx-xxxxx-xxxxx-xxxxx-xxxxx"
*         },
*         {
*             role = "custom role name"
*             service_principal = "My Service Prinicpal Name"
*         }
*     ]
* }
* ```
*
* The above values can be set normally in a .tfvars file also if required
*
* ```terraform
* module "rbac" {
*   source               = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-role-assignment"
*   assignments          = var.assignments
*   resource_groups      = var.resource_groups
* }
* ```
* 
* >NB When passing group or service principal names, bear in mind that they are case-sensitive for Terraforn to perform
* lookups against Azure AD
* 
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/


# Get details of existing resource groups
data "azurerm_resource_group" "rg" {
  for_each = toset(var.resource_groups)
  name     = each.key
}

# Get user object IDs
data "azuread_user" "user" {
  count               = length(local.upn_list)
  user_principal_name = element(local.upn_list, count.index)
}

# Get group object IDs
data "azuread_group" "group" {
  count        = length(local.group_list)
  display_name = element(local.group_list, count.index)
}

# Get SP object IDs
data "azuread_service_principal" "sp" {
  count        = length(local.sp_list)
  display_name = element(local.sp_list, count.index)
}

# Create the role assignments resources from the final list
resource "azurerm_role_assignment" "ra" {
  count                = length(local.all_assignments)
  scope                = lookup(element(local.all_assignments, count.index), "scope")
  role_definition_name = lookup(element(local.all_assignments, count.index), "role")
  principal_id         = lookup(element(local.all_assignments, count.index), "id")
}
