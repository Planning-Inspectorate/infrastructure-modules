locals {
  app_settings = merge(
    var.app_settings,
    {
      DOCKER_ENABLE_CI = false
    }
  )
}
