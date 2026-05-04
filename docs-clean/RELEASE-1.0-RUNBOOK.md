# eMule Broadband Edition 1.0 Release Runbook

This runbook is the operator path for proving `emule-bb-v1.0.0`. Use it with
[RELEASE-1.0-CHECKLIST](RELEASE-1.0-CHECKLIST.md); the checklist records the
evidence and final ship decisions.

## Preflight

Start from the workspace root and keep all build/test operations behind the
supported workspace entrypoint.

```powershell
pwsh -File repos\eMule-build\workspace.ps1 validate
git -C repos\eMule-tooling status --short --branch
git -C repos\eMule-build status --short --branch
git -C repos\eMule-build-tests status --short --branch
git -C workspaces\v0.72a\app\eMule-main status --short --branch
```

Do not continue to tagging if any active repo has unrelated uncommitted changes
or if `validate` fails.

## Build And Native Test Proof

Run the release build and test baseline before live-network validation.

```powershell
pwsh -File repos\eMule-build\workspace.ps1 build-app -Config Debug -Platform x64
pwsh -File repos\eMule-build\workspace.ps1 build-app -Config Release -Platform x64
pwsh -File repos\eMule-build\workspace.ps1 build-tests -Config Debug -Platform x64
pwsh -File repos\eMule-build\workspace.ps1 build-tests -Config Release -Platform x64
pwsh -File repos\eMule-build\workspace.ps1 test -Config Debug -Platform x64
pwsh -File repos\eMule-build\workspace.ps1 test -Config Release -Platform x64
```

Record the command output summary and any report paths in the checklist rows
for the gates being closed.

## Live E2E Proof

Run the full maintained Release x64 live lane:

```powershell
pwsh -File repos\eMule-build\workspace.ps1 live-e2e -Config Release -Platform x64
```

The default aggregate run must include:

- `preference-ui`
- `shared-files-ui`
- `config-stability-ui`
- `shared-hash-ui`
- `startup-profile`
- `shared-directories-rest`
- `rest-api`
- `amutorrent-browser-smoke`
- `prowlarr-emulebb`
- `radarr-sonarr-emulebb`
- `auto-browse-live`

The primary release artifact is:

```text
repos\eMule-build-tests\reports\live-e2e-suite-latest\result.json
```

Release 1 cannot ship with any `failed` suite in this artifact. A live-network
suite may be accepted as `inconclusive` only when its child report proves the
product and harness behaved correctly and the checklist records the external
condition that prevented proof.

## Focused Diagnostic Runs

Use focused runs only to diagnose or close a specific gate. They do not replace
the final full live E2E run.

```powershell
pwsh -File repos\eMule-build\workspace.ps1 live-e2e -Config Release -Platform x64 -LiveSuite rest-api
pwsh -File repos\eMule-build\workspace.ps1 live-e2e -Config Release -Platform x64 -LiveSuite rest-api -RestStressBudget soak
pwsh -File repos\eMule-build\workspace.ps1 live-e2e -Config Release -Platform x64 -LiveSuite amutorrent-browser-smoke
pwsh -File repos\eMule-build\workspace.ps1 live-e2e -Config Release -Platform x64 -LiveSuite prowlarr-emulebb -LiveSuite radarr-sonarr-emulebb
```

Use `-SkipLiveSeedRefresh`, `-RestDownloadTriggerCount 0`, or `-LiveFailFast`
only for diagnosis. Do not use those reduced modes as final release proof.

## Ship Decision

After the final full run:

- update [RELEASE-1.0-CHECKLIST](RELEASE-1.0-CHECKLIST.md) with command,
  commit, artifact, status, and ship decision evidence
- confirm every gate is `Passed` or `Inconclusive Accepted`
- confirm every release candidate is shipped, deferred, or promoted
- confirm release notes use `eMule broadband edition` as the full product name
  and `eMule BB` as the compact app/mod name
- create the annotated tag only after the checklist is complete

The Release 1 tag is:

```text
emule-bb-v1.0.0
```

The release ZIP assets must be named:

```text
eMule-broadband-1.0.0-x64.zip
eMule-broadband-1.0.0-arm64.zip
```
