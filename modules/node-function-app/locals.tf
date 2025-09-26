locals {
  app_settings = {
    # override host.json file log level
    # see https://learn.microsoft.com/en-us/azure/azure-functions/configure-monitoring?tabs=v2#configure-log-levels
    # and https://learn.microsoft.com/en-us/azure/azure-functions/functions-host-json#override-hostjson-values
    AzureFunctionsJobHost__logging__fileLoggingMode   = "debugOnly"
    AzureFunctionsJobHost__logging__logLevel__default = "Warning"

    SCM_DO_BUILD_DURING_DEPLOYMENT = false
    # run from the zip file
    # see https://learn.microsoft.com/en-gb/azure/azure-functions/run-functions-from-deployment-package#
    WEBSITE_RUN_FROM_PACKAGE = 1
  }
}
