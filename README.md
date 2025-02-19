# Semantic Release Action

<!-- toc -->

* [Description](#description)
* [Inputs](#inputs)
* [Outputs](#outputs)
* [Defaults](#defaults)
  * [Branches](#branches)
  * [Plugins](#plugins)
  * [Release Rules](#release-rules)
* [Usage](#usage)
* [Examples](#examples)
  * [Dry Run](#dry-run)
  * [Create Release](#create-release)
  * [Using output variables set by semantic-release in the same job](#using-output-variables-set-by-semantic-release-in-the-same-job)
  * [Using output variables set by semantic-release in a different job](#using-output-variables-set-by-semantic-release-in-a-different-job)
  * [Only run a subsequent step if a new release was successfully published](#only-run-a-subsequent-step-if-a-new-release-was-successfully-published)
  * [Running semantic-release on a Pull Request](#running-semantic-release-on-a-pull-request)
* [Contributing](#contributing)
  * [Commit style](#commit-style)
  * [Pre Commit](#pre-commit)
    * [Using Windows PowerShell](#using-windows-powershell)
    * [Using Mac, Linux or WSL with Python installed](#using-mac-linux-or-wsl-with-python-installed)

<!-- Regenerate with "pre-commit run -a markdown-toc" -->

<!-- tocstop -->

<!-- action-docs-description source="action.yml" -->
## Description

This action runs [Semantic Release](https://github.com/semantic-release/semantic-release), it leverages various plugins to analyse commits, generate release notes and create GitHub Releases.
<!-- action-docs-description source="action.yml" -->

<!-- action-docs-inputs source="action.yml" -->
## Inputs

| name | description | required | default |
| --- | --- | --- | --- |
| `node-version` | <p>The version Node to use e.g. <code>22, 22.4.1, &gt;=18, lts/* latest</code></p> | `false` | `lts/*` |
| `dry-run` | <p>Flag to indicate whether Semantic Release is ran in <code>dry-run</code> mode</p> | `false` | `false` |
<!-- action-docs-inputs source="action.yml" -->

<!-- action-docs-outputs source="action.yml" -->
## Outputs

| name | description |
| --- | --- |
| `new-release-published` | <p>Either <code>true</code> if a release has been successfully published or <code>false</code> if not</p> |
| `release-version` | <p>The new releases full semantic version, e.g. <code>2.3.1</code></p> |
| `release-major-version` | <p>The new releases major version number, e.g. <code>2</code></p> |
| `release-minor-version` | <p>The new releases minor version number, e.g. <code>3</code></p> |
| `release-patch-version` | <p>The new releases patch version number, e.g. <code>1</code></p> |
| `release-type` | <p>The semver type of the release, e.g. <code>major</code>, <code>minor</code>, <code>patch</code></p> |
<!-- action-docs-outputs source="action.yml" -->

> All outputs can also be accessed via their environment variable counter parts,
> they are named the same but use screaming snake case.
> For example, the `new-release-published` output can be accessed via the `NEW_RELEASE_PUBLISHED` environment variable.

## Defaults

### Branches

By default, releases will only happen from the following branches:

- main
- master

### Plugins

These are the default plugins defined in `.releaserc.json`, note they are ran in the order they are specified.

- commit-analyzer
- release-notes-generator
- exec
- github

### Release Rules

By default, semantic-release uses [Angular Commit Message Conventions](https://github.com/angular/angular/blob/master/CONTRIBUTING.md#-commit-message-format). Below are the rules used to determine the release type.

| Type      | Scope       | Release |
|-----------|-------------|---------|
| feat      |             | minor   |
| refactor  |             | minor   |
| fix       |             | patch   |
| perf      |             | patch   |
| ci        | deploy      | patch   |
| chore     | deploy      | patch   |
| style     |             | patch   |
|           | no-release  | false   |

<!-- action-docs-usage action="action.yml" project="mdit/workflows" version="main" -->
## Usage

```yaml
- uses: mdit/workflows@main
  with:
    node-version:
    # The version Node to use e.g. `22, 22.4.1, >=18, lts/* latest`
    #
    # Required: false
    # Default: lts/*

    dry-run:
    # Flag to indicate whether Semantic Release is ran in `dry-run` mode
    #
    # Required: false
    # Default: false
```
<!-- action-docs-usage action="action.yml" project="mdit/workflows" version="main" -->

## Examples
>NOTE: All examples reference the main branch; however, for production workflows, it's recommended to pin the version to a specific release.

### Dry Run

```yaml
name: Semantic Release Dry Run

on:
  pull_request:

jobs:
  dry-run:
    name: Dry Run
    runs-on: ubuntu-latest
    permissions:
      contents: write # dry-run mode still requires write access for semantic release to load
      id-token: write
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Semantic Release Dry Run
        uses: mdit/workflows@main
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          dry-run: true

```

### Create Release

```yaml
name: Semantic Release

on:
  push:
    branches:
      - main

jobs:
  release:
    name: Release
    runs-on: ubuntu-latest
    permissions:
      contents: write
      issues: write
      pull-requests: write
      id-token: write
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Release
        uses: mdit/workflows@main
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

### Using output variables set by semantic-release in the same job

```yaml
name: Semantic Release Outputs

on:
  push:
    branches:
      - main

jobs:
  release:
    name: Release Outputs
    runs-on: ubuntu-latest
    permissions:
      contents: write
      issues: write
      pull-requests: write
      id-token: write
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Release
        uses: mdit/workflows@main
        id: semantic-release
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

      - name: Accessing Outputs
        run: |
          # Subsequent steps will be able to access all of the semantic release outputs
          echo ${{ steps.semantic-release.outputs.new-release-published }}
          echo ${{ steps.semantic-release.outputs.release-version }}
          echo ${{ steps.semantic-release.outputs.release-major-version }}
          echo ${{ steps.semantic-release.outputs.release-minor-version }}
          echo ${{ steps.semantic-release.outputs.release-patch-version }}
          echo ${{ steps.semantic-release.outputs.release-type }}

          # We can also access the outputs via environment variables
          echo "$NEW_RELEASE_PUBLISHED"
          echo "$RELEASE_VERSION"
          echo "$RELEASE_MAJOR_VERSIO"
          echo "$RELEASE_MINOR_VERSION"
          echo "$RELEASE_PATCH_VERSION"
          echo "$RELEASE_TYPE"
```

### Using output variables set by semantic-release in a different job
```yaml
name: Semantic Release Job Outputs

on:
  push:
    pull_request:
    branches:
      - main

jobs:
  release:
    name: Release
    runs-on: ubuntu-latest
    outputs:
      version: ${{ steps.semantic-release.outputs.release-version }}
    permissions:
      contents: write
      issues: write
      pull-requests: write
      id-token: write
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          fetch-depth: 0
          ref: ${{ github.head_ref }}

      - name: Release
        uses: mdit/workflows@main
        id: semantic-release
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
  output:
    name: Release Outputs
    needs: release
    runs-on: ubuntu-latest
    steps:
      - name: Release Job Outputs
        run: |
          echo "${{ needs.release.outputs.version }}"
```

### Only run a subsequent step if a new release was successfully published
```yaml
name: New Release Published

on:
  push:
    branches:
      - main

jobs:
  release:
    name: Release
    runs-on: ubuntu-latest
    permissions:
      contents: write
      issues: write
      pull-requests: write
      id-token: write
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Release
        uses: mdit/workflows@main
        id: semantic-release
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

      - name: docker push version
        if: steps.semantic-release.outputs.new-release-published == 'true'
        run: |
          docker tag some-image some-image:$TAG
          docker push some-image:$TAG
        env:
          TAG: v$RELEASE_VERSION
```

### Running semantic-release on a Pull Request
When Semantic Release is invoked from a PR, it will automatically run in `dry-run` mode. The output variables will be determined by the current commits in the PR, this can be extremely helpful when using outputs elsewhere in the workflow.

> NOTE: `fetch-depth` & `ref` are required when checking out a PR and running Semantic Release. Without these, the release will trigger from an undefined branch and no outputs will be generated.

```yaml
name: Running Semantic Release on a Pull Request

on:
  push:
    pull_request:

jobs:
  release:
    name: PR Mode
    runs-on: ubuntu-latest
    permissions:
      contents: write
      issues: write
      pull-requests: write
      id-token: write
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          fetch-depth: 0
          ref: ${{ github.head_ref }}

      - name: Release
        uses: mdit/workflows@main
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

      - name: Terraform Plan
        uses: mdit/terraform-run@main
        with:
          terraform-variables: release_version=$RELEASE_VERSION
```


## Contributing

### Commit style

All commits should be done using the [Conventional Commit](https://www.conventionalcommits.org)
standard.

```git
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

For example: `feat: adding some awesome feature` or `chore: removing redundant config`


### Pre Commit

Make sure to set the pre-commit hooks before contributing to this repo:

```sh
pre-commit install
```

#### Using Windows PowerShell

Open Windows PowerShell using the 'Run as Administrator' option, paste the code snippet below into the terminal, then
hit enter:

```powershell
  if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
      Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
      [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
      Invoke-Expression -Command $(
          (New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
  }
  choco install tflint -y
  choco install terraform-docs -y

  choco install python312 -y
  py -m pip install pre-commit
```

Now close Windows PowerShell and reopen it, this time *without* administrative privileges. **Change the current working
directory to the root of your cloned repository**, then run the below command:

```powershell
  py -m pre_commit install
```

#### Using Mac, Linux or WSL with Python installed

```bash
  pip install pre-commit
  pre-commit install
```
