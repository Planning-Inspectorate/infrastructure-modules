locals {
  tags = merge(
    var.common_tags,
    {
      ServiceName = var.name
      Region      = "Global"
    }
  )
}
