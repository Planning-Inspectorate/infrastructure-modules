/*
    Terraform configuration file defining variables
*/
variable "environment" {
  type        = string
  description = "The environment name. Used as a tag and in naming the resource group"
}

variable "application" {
  type        = string
  description = "Name of the application"
}


variable "location" {
  type        = string
  description = "The region resources will be deployed to"
  default     = "northeurope"
}

variable "tags" {
  type        = map(string)
  description = "List of tags to be applied to resources"
  default     = {}
}

variable "access_policies" {
  type        = list(map(any))
  description = <<EOL
List of map of list of string defining access policies for the Key Vault. 
See [terraform docs](https://www.terraform.io/docs/providers/azurerm/r/key_vault.html#certificate_permissions) for more info.
Each map item in the list can define a combination of *user_principal_names*, *group_names* or *object_ids* with a combination of **secret_permissions**, **key_permissions**, **certificate_permissions** or **storage_permissions**. 
All fields are not required to be defined in each map. Eg
\```
[
  {
    user_principal_names = ["user1@domain","user2@domain"]
    certificate_permissions = ["create","delete","get","import"]
  },
  {
    group_names = ["group","another_group"]
    secret_permissions = ["get","list","set"]
    key_permissions = ["get","list"]
  },
  {
    object_ids = ["xxxxxxx-xxxxx-xxxx-xxxxxx","yyyyyy-yyyyy-yyyyy-yyyyyy"]
    group_names = ["some_group"]
    storage_permissions = ["backup","restore"]
  }
]
\```
EOL
  default     = []
}