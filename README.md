# Semantic Release Action

<!-- toc -->

* [Description](#description)
* [Inputs](#inputs)
* [Outputs](#outputs)
* [Runs](#runs)

<!-- Regenerate with "pre-commit run -a markdown-toc" -->

<!-- tocstop -->

<!-- action-docs-header source="action.yml" -->

<!-- action-docs-header source="action.yml" -->

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

<!-- action-docs-runs source="action.yml" -->
## Runs

This action is a `composite` action.
<!-- action-docs-runs source="action.yml" -->
