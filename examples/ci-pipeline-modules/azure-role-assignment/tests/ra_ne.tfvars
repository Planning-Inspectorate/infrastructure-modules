

/*
    NB These two resource groups are not created by the Terraform module, but are pre-created by the CI pipeline for it.
*/

resource_groups = ["ci-long-lived-monitor-test-northeurope"]

assignments = [
    {
        role = "owner"
        id = "56c390cd-6ae7-4a1e-acb4-94f60fb34c15"
    },
    {
        role = "contributor"
        user = "adrian.weetman@hiscox.com"
    },
    {
        role = "storage blob data contributor"
        user = "edward.williams@hiscox.com"
    },
    {
        role = "owner"
        group = "Azure_RBAC_HiscoxAllSubscriptions_SubscriptionAdmin"
    },
    {
        role = "contributor"
        id = "48a3147b-667a-48f2-be4f-fc70833a4793"
    },
    {
        role = "reader"
        group = "!PlatformServicesGroup"
    },
    {
        role = "owner"
        service_principal = "bamboo-hiscoxplatformdevtest-automation"
    }
]
