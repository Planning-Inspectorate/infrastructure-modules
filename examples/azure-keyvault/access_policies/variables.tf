variable "keyvault_id" {
  type = string
  description = "Id of the Azure Key Vault"
}

variable "read_users" {
  type = list(string)
  description = "List of usernames or service accounts that will be granted read access to keys, secrets, and certificates"
  default = []
}

variable "write_users" {
  type = list(string)
  description = "List of usernames or service accounts that will be granted write access to keys, secrets, and certificates"
  default = []
}

variable "admin_users" {
  type = list(string)
  description = "List of usernames or service accounts that will be granted admin access to keys, secrets, and certificates"
  default = []
}

variable "read_ids" {
  type = list(string)
  description = "List of principal ids that will be granted read access to keys, secrets, and certificates"
  default = []
}
variable "write_ids" {
  type = list(string)
  description = "List of principal ids that will be granted write access to keys, secrets, and certificates"
  default = []
}
variable "admin_ids" {
  type = list(string)
  description = "List of principal ids that will be granted admin access to keys, secrets, and certificates"
  default = []
}
