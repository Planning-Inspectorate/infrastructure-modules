variable "environment" { # afd is global resource; could just be stood up in one place
  description = "The environment resources are deployed to e.g. 'dev'"
  type        = string
}

variable "location" {
  description = "The location resources are deployed to in slug format e.g. 'uk-west'"
  type        = string
  default     = "uk-west" # could be changed to south and have the AZs
}
