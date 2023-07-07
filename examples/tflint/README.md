# TFLint in terraform modules

## Description

[TFLint](https://github.com/terraform-linters/tflint) is a terraform linting tool that can help to highlight simple syntax errors and encourage best practice is writing Terraform code.

It is available with ruleset plugins for the major cloud vendors (we are using the [azure plugin](https://github.com/terraform-linters/tflint-ruleset-azurerm)) and an [SDK](https://github.com/terraform-linters/tflint-plugin-sdk) to develop your own additional rules if required (developed in GOLANG).

---
## Implementation

Within this terraform-modules repo, the template pipelines have been modified to incorporate a job that runs tflint against the terraform code for each module.

TFLint itself and the azure ruleset plugin are installed in the Docker image used for the ADO agents, which is defined in [this repository](https://dev.azure.com/hiscox/gp-psg/_git/psg-cicd-containers) - the appropriate [Dockerfile](https://dev.azure.com/hiscox/gp-psg/_git/psg-cicd-containers?path=%2Fado%2FDockerfile) is here.

The [tflint config file](/tflint/.tflint.hcl) defines simply that the azure plugin should be enabled, though other options are available to further customise the behaviour if required.

The updated templates for pipeline [stages](/.azure-pipelines/templates/terraform-stage-ci.yml) and the TFLint [job](/.azure-pipelines/templates/terrafrom-step-tflint.yml) define how and when that test should run, and also a dependency for the main pipeline eg if tflint fails, the rest of the pipeline will not run and be failed also.

Any test failures will be published to the Tests tab/page for the pipeline run in Azure DevOps [example](https://dev.azure.com/hiscox/gp-psg/_build/results?buildId=9287&view=ms.vss-test-web.build-test-results-tab).

Unfortunately tflint does not report test successes for rules that are not triggered so the reports will only be published when there are failures - don't panic when you aren't getting a nice all green report!

---
## Roadmap - possible future developments

- [x] Possible pipeline variable to specify custom tflint.hcl config file on a per-pipeline basis, eg to pass tfvars files or specific variable to tflint for comprehensive testing.
- [] Develop Hiscox ruleset plugin to test eg compliance with naming standards
- [] Integrate more closely with existing terratest pipeline through [utilities repo](https://github.com/hiscox/terratestutilities)