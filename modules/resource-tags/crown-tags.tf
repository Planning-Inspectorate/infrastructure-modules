variable "base_tags" {
  type        = map(string)
  description = "Baseline tags defined at the project level"
}

variable "extra_tags" {
  type        = map(string)
  description = "Resource-specific tags to merge with baseline"
  default     = {}
}

output "tags" {
  description = "output for the tags"
  value = merge(var.base_tags, var.extra_tags)
}
