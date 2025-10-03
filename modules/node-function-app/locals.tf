locals {
  app_settings = {
    SCM_DO_BUILD_DURING_DEPLOYMENT = false
    # run from the zip file
    # see https://learn.microsoft.com/en-gb/azure/azure-functions/run-functions-from-deployment-package#
    WEBSITE_RUN_FROM_PACKAGE = 1
  }
}
