/**
* Terraform Azure Role Assignment module
* ======================================
* 
* CI for Role Assignments
*
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

module "rbac" {
  source          = "../../azure-role-assignment"
  assignments     = var.assignments
  resource_groups = var.resource_groups
}