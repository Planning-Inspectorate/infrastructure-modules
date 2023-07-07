# Adding a new module

Before you start

- Ensure the requirement/use case is valid
- Discuss design with PSG

Then

- Clone this repo
- Create a branch for your work and switch to it
- Create a folder in the root of the terraform-modules repo for your module.
  It should be named for the specific type of resource building block it creates, words separated by hyphens.
  >NB We use "azure" instead of "azurerm" for brevity's sake - there is no support for Classic Azure Service Manager resources.
- Write code
- Test locally

When your module works locally

- Make sure you have a terraform-flavoured `.gitignore` file in the root of your module folder
- Check there are no secrets (passwords, APIkeys etc) in any `*.tfvars` files
- Commit your changes

Make sure there's a pipeline to build your module

- In the `ci-pipeline-modules` folder duplicate a module and name it after your new module.
- Update the `main.tf` to pull your new module in its most simple form and fill in any params across `variables.tf`
- Update the `tfvars` and `go` files under its `tests` folder, note the `tfvars` file should have a unique name and the `go` file should contain a line of code referencing the name of your `tfvars` exactly
- In the `/.azure-pipelines` folder, create a copy of the `template-module.yml` file and name it `<your-module-folder-name>.yml`, eg if your module folder is called `azure-newfangled-doohickey` then rename the copied file `azure-newfangled-doohickey.yml`
- Perform a search and replace in the new file - replacing the phrase `template-module` with your module name eg `azure-newfangled-doohickey`
- Edit the parameters as required towards the bottom of the file for any specific variables, variable groups and sensitive variables you may need to include.
  >NB Do NOT put any sensitive variables in this file - if your pipeline will need any they should be coming from a variable group, which you create in the Azure DevOps portal and then reference in the pipeline.

  > You should also ensure that you include any sensitive variable names in the `sensitiveVariableNames` parameter so that the pipeline will automatically pass them into the environment for the Terraform scripts
- Save the file with your required changes and commit it
- Push your branch
- Create the pipeline either in the Azure DevOps portal by referencing your newly-created .yml file, or by using the Azure CLI extension for Azure DevOps. The command for this (assuming you are logged in and authenticated to the Hiscox Azure DevOps org) would be:

  ```bash
  az pipelines create --name "azure-newfangled-doohickey" --folder-path "\terraform-modules" --yml-path .\.azure-pipelines\azure-newfangled-doohickey.yml
  ```
  
  This will immediately trigger the pipeline for your current branch. If you do not want this to run immediately be sure to add the `--skip-run` parameter to the command above

## NB

- No tag moving!
- No latest tag faff. It causes more pain
