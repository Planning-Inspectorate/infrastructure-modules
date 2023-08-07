# Introduction

We are using a script to power release automation.

The script is Tag-Repo.ps1
It is invoked by the release-automation.yml

This script and pipeline handle the automation of git taggingand branching to represent new (and old) major/minor versions

## Assumptions

  1. We derive new version numbers based on presence of existing versions in format <`major`>.<`minor`>
  1. We depend upon an existing tagged commits on the branch to do this
  1. The following logic is designed to operate over long-lived branches, as specified in trigger part of the yml pipeline
  1. Tagging will only occur on the master branch and branches of the format <`digits`>.x, e.g. 14.x. These represent branches for old major versions
  1. taginfo.json contains metadata required to correctly tag
      - major_version_number: representation of the major version number, e.g. "2"
  1. Target ADO repo has been set up with permissions fro Project Collection Build Service. See <https://docs.microsoft.com/en-us/azure/devops/pipelines/scripts/git-commands?view=azure-devops&tabs=yaml>
      i.e. ensure service is allowed to contribute, push tags and create branches

## How a new major version is created (and create branch for old major version)

- Tagging will take place based on the value of major_version_number
- So to create a new major version, increment this value and let the pipeline automate the tagging/branching
- If commits are made with no changes to major_version_number, a tag representing a minor update is created
- But if commits are made with an incremented value to major_version_number, a tag representing a major update is created
  - At the same time, a branch is created representing the original major version, onto which more commits may be made
