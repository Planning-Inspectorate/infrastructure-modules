# infrastructure-modules

- [infrastructure-modules](#infrastructure-modules)
  - [Installation / Setup](#installation--setup)
    - [Install tfenv and Terraform](#install-tfenv-and-terraform)
    - [Install pre-commit hooks](#install-pre-commit-hooks)
    - [Install and use Terraform-docs](#install-and-use-terraform-docs)
    - [Install and use TFLint](#install-and-use-tflint)
    - [Install Trivy](#install-trivy)
    - [Install commitlint](#install-commitlint)
    - [Install and use Checkov](#install-and-use-checkov)
  - [TODO](#todo)

## Installation / Setup

The main tool required to work with this repo is Terraform.

However, if you are running macOS or Linux it is recommended you use a version manager for ease in case working with multiple Terraform versions. For this you can use [tfenv](https://github.com/tfutils/tfenv).

### Install tfenv and Terraform

Install tfenv ([Homebrew](https://brew.sh/)):

```bash
brew install tfenv
```

Install tfenv manually by checking out the repo and adding `.tfenv/bin` to your `$PATH`:

```bash
git clone https://github.com/tfutils/tfenv.git ~/.tfenv
echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bash_profile
```

Install Terraform using tfenv:

```python
tfenv install 1.1.6
```

### Install pre-commit hooks

Install pre-commit (requires Python/Pip):

```python
pip install pre-commit
```

Install pre-commit ([Homebrew](https://brew.sh/)):

```bash
brew install pre-commit
```

Once pre-commit is installed, configure it in the project by running from the root:

```bash
pre-commit install
```

Pre-commit is configured using the `.pre-commit-config.yaml` file in the root of the project. In order for it to run, the required tools need to be installed.

### Install and use Terraform-docs

Install terraform-docs ([Homebrew](https://brew.sh/)):

```bash
brew install terraform-docs
```

Install terraform-docs ([Chocolatey](https://chocolatey.org/)):

```bash
choco install terraform-docs
```

Terraform-docs automates Terraform documentation and makes it available in Markdown syntax. These have been placed in `README.md` files within each Terraform module throughout the repository.

This documentation has been automated using pre-commit hooks (see above). The `README.md` file for each Terraform module contains tags:

```bash
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
```

When the pre-commit hook runs then Terraform-docs will generate the documentation and add to the space between the tags.

If you create a new Terraform module, simply add a `README.md` file and add the above tags. Terraform-docs will then run for this module each time you make a commit.

To run Terraform-docs for the whole repository, run:

```bash
pre-commit run -a terraform-docs
```

### Install and use TFLint

Install tflint (Bash script Linux):

```bash
curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
```

Install tflint ([Homebrew](https://brew.sh/)):

```bash
brew install tflint
```

Install tflint ([Choolatey](https://chocolatey.org/)):

```bash
choco install tflint
```

TFLint is configured via the `.tflint.hcl` file in the project root. It needs to be initialised before running.

```bash
tflint --init
```

### Install Trivy

Install Trivy: <https://aquasecurity.github.io/trivy/v0.56/getting-started/installation/>
scans all configuration files for misconfiguration issues

```bash

sudo apt-get update

sudo apt-get install -y wget apt-transport-https gnupg lsb-release

wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo "deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list

sudo apt-get update

sudo apt-get install -y trivy

trivy --version

```

### Install commitlint

This tool will need npm installed

Install commitlint: <https://commitlint.js.org/guides/getting-started.html>

echo "module.exports = { extends: ['@commitlint/config-conventional'] };" > commitlint.config.js

chmod +x .git/hooks/commit-msg

- #!/bin/sh
npx --no-install commitlint --edit $1

```bash

npm install --save-dev @commitlint/cli @commitlint/config-conventional



```

### Install and use Checkov

Install Checkov (Python/Pip):

```bash
pip install checkov
```

Install Checkov ([Homebrew](https://brew.sh/)):

```bash
brew install checkov
```

Checkov runs a scan of the infrastructure as code, and can be pointed a Terraform module using the -d flag:

```bash
checkov -d /path/to/module
```

In some scenarios Checkov may report configuration issues that are intentional. In order to bypass these checks, you can add a comment to the Terraform resource it complains about like so:

```bash
resource "azurerm_storage_account" "my_storage_account" {
  #checkov:skip=CKV_AZURE_109: Skip reason

  ...
}
```

Where in this example, `CKV_AZURE_109` is the check to bypass.

## TODO

Infrastructure as Code (IaC) modules for use across environments.

TO DO: Finish modules v2
