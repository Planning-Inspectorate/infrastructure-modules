# terraform-modules

This repo contains building blocks for deploying terraform based components. Colloquially they are known as 'modules' and are designed to be consumed from seperate and specific terraform repositories which define application ecosystems, aka an environment for hosting an application. These are known as 'consumers'.

The general strucutre is such:

* A directory per cloud component e.g. an Azure Load Balancer
* A CI directory containing very simple modules to encompass the actual building block modules in the root. These are driven by pipleines to test the functionality of the modules is working as expected
* An examples directory showing how to construct a consumer repository type by gluing these components together
  * This has the added benefit of acting as integration tests. So for a module with optional parameters like `log_analytics_workspace.id` an example can glue the analytics module into something else. When changing modules the examples can point their sources at ../../mod_name so that you know the module changes work and it also still integrates into other modules correctly

Additionality:

* All module README.md and example diagrams are generated through Terradocs and pUml, ensuring that documentation remains up to date as engineers make modifications

The repository is laid out thus:

```bash
/terraform-modules
  /component1
   --locals.tf
   --main.tf
   --data.tf
   --version.tf
   --README.md
  /component2
  /component3
  /ci-pipeline-modules
    /component1
  /examples
   /public-static-website
    --schematic.png
    --locals.tf
    --main.tf
    --data.tf
    --version.tf
    --README.md
   /function-app-w-log-analytics
```

When a Business Unit wishes to deploy infrastructure they will create a consumer repository and can use one of the examples as a template. It would use Terraform 'module' blocks to target components aka modules from this repository. E.g:

```terraform
module "storage-account" {
  source        = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-storage-account?ref=1.4.0"
  input_param_1 = var.var1
  input_param_2 = var.var2
  input_param_3 = var.var3
}
module "log-analytics" {
  source        = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-log-analytics?ref=2.2.0"
  input_param_1 = module.storage-account.output_param_1
  input_param_2 = var.var4
  input_param_3 = var.var5
}
```

Every modules README.md contains one or more example code snippets which allows a resource to utilised as quickly as possible.

## Resource Group Creation

Every module will build its own resource group when called by a consumer unless you specify your own with the input param `resource_group_name`.

Internally a module will check to see if `resource_group_name` is empty. If so it'll create a resource group and place what it is provisioning into it. To handle auto creation or a user input all modules access the name through the data defintion i.e `data.azurerm_resource_group` when telling a resource which RG to live in. See `template-module` for the structure and the `examples` dir t see it in action.

## CI

To drive nightly CI and Apply-Destroys on commit we have chosen to use [Terratest](https://github.com/gruntwork-io/terratest).

For a consumer BU wondering how to drive a terraform deployment in an automated pipleine take a look at the `template-consumer` under the `examples` directory as there are multiple options available (for consumers curious about Terratest we would recommend structuring the Go test file differently for a consumer repo when compared to one of these modules).

Written in Go Terratest allows an engineer to invoke Terraform (and other tools such as Packer and Helm) from Go tests which permits the use of other go libraries to do things like:

* Test NSGs and firewalls by using REST libraries post-provision
* Execute shell commands and such like
* Transferring data via SC
* Templating Helm charts
* Testing docker images

Additionally the Terratest library contains a number of modules of helper functions which can make it easier to work with (there are many more examples in the above link):

* Azure, e.g Retrieving tags and VM sizes
* Git, e.g checking branches/tags
* Random, e.g generating random data sets to avoid conflcits and allow for concurrency in testing

This gives us the oppotunity of turning the `examples/` directory into a set of integration tests.

### Using Terratest

Ensure you have configured a Go workspace and have Go installed, check their website if in doubt.

Take a terraform repository and create a directory called tests. Initialse tests as a Go module (for handling dependencies) by executing `go mod init <module-name>` from within the directory.

`<module-name>` typically takes the form of domain/user/repository so for an example ADO repo it would look like:

`go mod init 'dev.azure.com/hiscox/projecy-name/terraform-repo'`

To see the structure of a Go test file take a look at `ci-pipeline-modulestemplate-module/tests/template_module_test.go`.

To run the tests:

```bash
cd test
go test -v -timeout 30m
```

## Contribute

See CONTRIBUTING.md

## History Lesson

Previously there were ~170 Terraform repositories setup as one of the following types:

* Consumer
* Module
* Consumer-Module Hybrid

A Consumer is owned by a Business Unit and defines an application ecosystem. This deploys a number of infrastructure components derived from other repositories. For instance in order to deploy a system of virtual machines and a load balancer you would call a separate module for the VM and a separate module for the load balancer from within your Consumer repository.

A Module is thought of as a component building block. It is intended to only be consumed by other code bases. An example Module would be a repository defining an Azure Load Balancer.

A Consumer-Module Hybrid sits between the two previous types. It is consumed by other repositories yet can also be invoked to deploy standalone infrastructure. An example of which would be Azure Keyvault.

Problems with this model:

* Volume - large number of repositories some of which have ownership split between different Business Units
* Hybrids complicate pipelines and code changes as they are executed in two fashions
* Inconsistent style and code quality - around 60 repositories were so old we'd opt to completely rewrite them to modern standards if we needed to deploy their cloud components again
* New features are added to a Module but it's never publicised for consumption
* New feature added for a single BU/team, could be inconsistent with how other BUs consume it, floating branches/tags etc
* Enhancing a Consumer can be frustrating due to Module dependency change, tag after tag echoed through code bases
* Inconsistent CI and deploy pipelines

Hence we decided to migrate to this new single repository model for building-blocky terraform which brings these benefits:

* Clear ownership between Consumers and Modules
* Greater collaboration on Modules to a maintain consistent code quality
* Knowledge sharing and upskilling between distributed engineers
* Nightly CI to apply + destroy all modules
* Proper release notes can be published based on the commit history so that new tags are publicised to Business Units for consumption
* User experience - when upgrading a consumer it's frustrating having multiple branches open across several repos and needing to clone and switch around everywhere, centralising Modules alleviates this somewhat

## TO-DO List
# High priority
* ABANDONED - Rework the file shares in `azure-storage-account` so we can create complex directory structures (each parent directory has to be individually created, perhaps some logic aorund splitting a string based on "/")
* Azure-vm/base, overiding storage diagnoatic account doesn't work when your consumer builds the storage in the same repo/pipeline

# Med priority
* Unique names for log analytics, data factory and maybe KV (append rand char)

# Low priority
* update app gateway module to cupport certificate retreival and assignment
* change keyvault access-policies from counts into for_each, otherwise all polices are recreated whenever one of them changes
* add writeup of terratest and PSDeploy tools in example template readme

# To investigate
* sql - short term backups and set_ad_users script conversion - Can it be done in TF now instead of the PS scripts
* Testing whether provider credentials change from TF15 deprecating arm_xxx requires action
* Use `one()` function in `azure-key-keyvault/main` to convert single element lists into a string for SP access policy
* Default KV soft delete and purge protection to on
* Defaulting diagnostic logging to on across all modules

# What are these
* data_disk.tpl for linux for mounting stuffs

# Big breaking changes for future consideration
* Use `one()` function in `azure-vm/base` to convert single element lists into a string (do not do this yet!)

# To Do
* Still in experimental support 10/2021 - Consider applying (if out of experimental support), opportunities to use the new optional object type attributes. For example, the `azure-app-service` module supports managed identities for the app service and function app resources. This is based on a variable being used to determine whether or not the dynamic identity block should be added. And given whether a system- or user-assigned identity is used, the identity_ids attribute may be required. Hence it should be an optional attribute in a variable of type object. This way of doing it is preferable to the current way its implemented.
* Storage account file share tier. Currently not supported in TF
* Still not functionally equivilent 10/2021 - Replace Diagnostic Agent Extentsion and Log Extension with Azure Monitor Agent once it is feature complete and GA: https://docs.microsoft.com/en-us/azure/azure-monitor/vm/monitor-virtual-machine