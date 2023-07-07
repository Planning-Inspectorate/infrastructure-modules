resource "random_string" "random_name" {
  length  = 6
  special = false
  upper   = false

  keepers = {
    environment = var.environment
    business    = var.business
    service     = var.service
  }
}

