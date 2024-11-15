locals { app_settings = merge({
  SCM_DO_BUILD_DURING_DEPLOYMENT = false
  # run from the zip file
  # see https://learn.microsoft.com/en-gb/azure/azure-functions/run-functions-from-deployment-package#
  WEBSITE_RUN_FROM_PACKAGE = 1 },
  var.app_settings,
  var.use_app_insights ? {
APPINSIGHTS_INSTRUMENTATIONKEY = var.app_insights_instrument_key } : {}) }
