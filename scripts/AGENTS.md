# Scripts Rules

- Read `EMULE_WORKSPACE_ROOT\repos\eMule-tooling\docs\WORKSPACE_POLICY.md`
  before workspace work; this file only records the local scripts exception.
- All scripts in this directory must be compatible with Windows built-in `PowerShell.exe` (Windows PowerShell 5.1).
- This directory is the only exception to the workspace default `pwsh 7.6` requirement.
- Every `*.ps1` in this directory must declare `#Requires -Version 5.1`.
- All scripts in this directory must work on Windows 10 and Windows 11.
- PowerShell scripts in this directory must use the `category-purpose-action.ps1` naming convention.
- Matching launcher wrappers in this directory must use the `category-purpose-action.cmd` naming convention.
- New or updated scripts in this directory must include comment-based help and clear inline comments when behavior is not obvious.
