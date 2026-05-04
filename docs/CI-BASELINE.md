# CI Baseline

`eMule-tooling` owns the shared baseline CI used by the active eMule repos.

## Reusable Workflow

- workflow: `.github/workflows/reusable-baseline.yml`
- stable ref: `ci/v1`

Consumer repos should reference:

- `eMulebb/eMule-tooling/.github/workflows/reusable-baseline.yml@ci/v1`

Do not point long-lived branches at `@main`.

## Required Checks

Use these status names in branch protection:

- `Baseline / Privacy Guard`
- `Baseline / Basic Hygiene`

## Shared Scripts

- `ci/guard-tracked-files.ps1`
- `ci/check-basic-hygiene.ps1`

Each consumer repo keeps its own:

- `.github/workflows/baseline.yml`
- `manifests/privacy-guard/policy.v1.json`
