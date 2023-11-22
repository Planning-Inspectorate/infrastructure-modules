locals {
  service_name = var.service_name

  tags = merge(
    var.common_tags,
    {
      ServiceName = local.service_name
      Region      = "Global"
    }
  )
}
