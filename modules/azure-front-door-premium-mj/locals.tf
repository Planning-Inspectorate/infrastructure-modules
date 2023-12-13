# afd module: this one does seem clever but perhaps OTT
locals {
  common_tags = {
    managed-by  = "Terraform"
    environment = "Sandpit" # This could be a va
  }

  # location = var.azure.location != null ? var.azure.location : data.azurerm_resource_group.current.location

  # # {resource_group_id}/providers/Microsoft.Cdn/profiles/{profileName}/originGroups/{originGroupName}/origins/{originName}
  # origin_ids_by_origin_group = {
  #   for og_name, og_value in var.origin_groups :
  #   og_name => [
  #     for o_name, o_value in og_value.origins :
  #     "${data.azurerm_resource_group.current.id}/providers/Microsoft.Cdn/profiles/${var.name}/originGroups/${og_name}/origins/${o_name}"
  #   ] if og_value.origins != null
  # }
}
