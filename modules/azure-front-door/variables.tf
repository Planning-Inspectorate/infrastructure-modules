variable "common_tags" {
  description = "The common resource tags for the project"
  type        = map(string)
}

variable "domain_name" {
  description = "Public domain name"
  type        = string
}

variable "environment" {
  description = "Environment Name"
  type        = string
}

variable "frontend_endpoint" {
  description = "The endpoint for the frontend"
  type        = string
}

variable "location" {
  description = "The location the App Services are deployed to in slug format e.g. 'uk-south'"
  type        = string
}

variable "name" {
  description = "The name of the resource."
  type        = string
}

variable "sku_name" {
  description = "Specifies the SKU for this Front Door Profile."
  type        = string
}
