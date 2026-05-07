# eMule Broadband Edition 1.0 Release Checklist

This is the operator checklist for `emule-bb-v1.0.0`. It does not own gate
status; use [RELEASE-1.0](RELEASE-1.0.md) for release decisions and item docs
for detailed completion evidence.

Current status: the broadband branch is still pre-release stabilization. Do not
tag or package Release 1 until this checklist is complete.

## Gate Revalidation

- [ ] [RELEASE-1.0](RELEASE-1.0.md) shows every release gate as passed or
      explicitly accepted as inconclusive
- [ ] every gate item has current implementation evidence and validation
      artifacts in its item doc
- [ ] every candidate is shipped, promoted, or explicitly deferred in
      [RELEASE-1.0](RELEASE-1.0.md)
- [ ] any accepted inconclusive live-network result records the external
      condition that blocked proof

## Required Commands

- [ ] `pwsh -File repos\eMule-build\workspace.ps1 validate`
- [ ] `pwsh -File repos\eMule-build\workspace.ps1 build-app -Config Debug -Platform x64`
- [ ] `pwsh -File repos\eMule-build\workspace.ps1 build-app -Config Release -Platform x64`
- [ ] `pwsh -File repos\eMule-build\workspace.ps1 build-tests -Config Debug -Platform x64`
- [ ] `pwsh -File repos\eMule-build\workspace.ps1 build-tests -Config Release -Platform x64`
- [ ] supported native test command
- [ ] full Release x64 `live-e2e`
- [ ] `pwsh -File repos\eMule-tooling\ci\check-clean-worktree.ps1 -EmuleWorkspaceRoot .`

## Release Identity

- [ ] release notes use `eMule broadband edition` as the public product name
- [ ] release notes use `eMule BB` as the compact app/mod name
- [ ] annotated tag is `emule-bb-v1.0.0`
- [ ] x64 asset is `eMule-broadband-1.0.0-x64.zip`
- [ ] ARM64 asset is `eMule-broadband-1.0.0-arm64.zip`

## Final Operator Steps

- [ ] record final command summaries and artifact paths in the relevant gate
      item docs
- [ ] confirm no active workspace repo has unrelated uncommitted changes
- [ ] create release packages
- [ ] create the annotated tag only after package verification
