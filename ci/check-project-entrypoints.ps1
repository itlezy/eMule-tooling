#Requires -Version 7.6
[CmdletBinding()]
param(
    [string]$EmuleWorkspaceRoot
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $false

if ([string]::IsNullOrWhiteSpace($EmuleWorkspaceRoot)) {
    if (-not [string]::IsNullOrWhiteSpace($env:EMULE_WORKSPACE_ROOT)) {
        $EmuleWorkspaceRoot = $env:EMULE_WORKSPACE_ROOT
    } else {
        throw 'EMULE_WORKSPACE_ROOT or -EmuleWorkspaceRoot is required.'
    }
}

$EmuleWorkspaceRoot = [System.IO.Path]::GetFullPath($EmuleWorkspaceRoot)

function Resolve-WorkspacePath([string]$RelativePath) {
    [System.IO.Path]::GetFullPath((Join-Path $EmuleWorkspaceRoot $RelativePath))
}

function Assert-PathMissing([string]$PathToCheck) {
    if (Test-Path -LiteralPath $PathToCheck) {
        throw "Obsolete project entrypoint still exists: $PathToCheck"
    }
}

function Assert-FileContains([string]$PathToCheck, [string]$Pattern, [string]$Reason) {
    if (-not (Test-Path -LiteralPath $PathToCheck -PathType Leaf)) {
        throw "Required file is missing: $PathToCheck"
    }

    if (-not (Select-String -LiteralPath $PathToCheck -Pattern $Pattern -Quiet)) {
        throw $Reason
    }
}

function Assert-FileNotContains([string]$PathToCheck, [string]$Pattern, [string]$Reason) {
    if (-not (Test-Path -LiteralPath $PathToCheck -PathType Leaf)) {
        throw "Required file is missing: $PathToCheck"
    }

    if (Select-String -LiteralPath $PathToCheck -Pattern $Pattern -Quiet) {
        throw $Reason
    }
}

foreach ($variantRelativeRoot in @(
    'workspaces\v0.72a\app\eMule-main',
    'workspaces\v0.72a\app\eMule-v0.72a-oracle',
    'workspaces\v0.72a\app\eMule-v0.72a-build',
    'workspaces\v0.72a\app\eMule-v0.72a-bugfix'
)) {
    $appRoot = Resolve-WorkspacePath $variantRelativeRoot
    Assert-PathMissing (Join-Path $appRoot 'srchybrid\emule.sln')
    Assert-PathMissing (Join-Path $appRoot 'srchybrid\emule.slnx')
}

$buildWorkspaceScript = Resolve-WorkspacePath 'repos\eMule-build\workspace.ps1'
Assert-FileContains $buildWorkspaceScript 'srchybrid\\emule\.vcxproj' 'workspace.ps1 must build the app through srchybrid\emule.vcxproj.'
Assert-FileNotContains $buildWorkspaceScript 'emule\.slnx?' 'workspace.ps1 must not rely on emule.sln or emule.slnx.'

foreach ($activeDocPath in @(
    (Resolve-WorkspacePath 'repos\eMule-build\README.md'),
    (Resolve-WorkspacePath 'repos\eMule-build-tests\README.md'),
    (Resolve-WorkspacePath 'repos\eMule-tooling\README.md'),
    (Resolve-WorkspacePath 'repos\eMule-tooling\AGENTS.md'),
    (Resolve-WorkspacePath 'repos\eMule-tooling\docs\WORKSPACE_POLICY.md')
)) {
    Assert-FileNotContains $activeDocPath 'emule\.slnx?' "$activeDocPath must not describe emule.sln or emule.slnx as active build entrypoints."
    Assert-FileNotContains `
        $activeDocPath `
        '(?i)(^|\s|`|&)(?:&\s*)?msbuild(?:\.exe)?\s+(?:[./\\\w:-]+\.vcxproj|[./\\\w:-]+\.slnx?|/t:|/p:|-t:|-p:)' `
        "$activeDocPath must not document direct MSBuild command lines as active build entrypoints; use repos\eMule-build\workspace.ps1."
}

Write-Host 'Project entrypoint audit passed.'
