locals {
  app_settings = {
    SCM_DO_BUILD_DURING_DEPLOYMENT = false
    # run from the zip file
    # see https://learn.microsoft.com/en-gb/azure/azure-functions/run-functions-from-deployment-package#
    WEBSITE_RUN_FROM_PACKAGE = 1
  }

  app_insights = {
    create = var.app_insights_instrument_key == null && var.use_app_insights
    use    = var.app_insights_instrument_key != null
  }
  # either use the provided key, the created key, or none
  app_insights_instrument_key = local.app_insights.use ? var.app_insights_instrument_key : (
    local.app_insights.create ? azurerm_application_insights.function_app_insights[0].instrumentation_key : null
  )
}
