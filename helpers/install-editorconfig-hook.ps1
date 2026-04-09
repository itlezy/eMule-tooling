#Requires -Version 7.2
[CmdletBinding()]
param(
    [string]$RepoRoot = '.',
    [switch]$Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $false

function Resolve-RepoRoot {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Candidate
    )

    $candidatePath = [System.IO.Path]::GetFullPath($Candidate)
    $repoRootOutput = @(& git -C $candidatePath rev-parse --show-toplevel 2>$null)
    $exitCode = $LASTEXITCODE
    $repoRoot = ($repoRootOutput | Select-Object -First 1)
    if ($exitCode -ne 0 -or [string]::IsNullOrWhiteSpace($repoRoot)) {
        throw "Unable to resolve a Git repo root from '$candidatePath'."
    }

    return [System.IO.Path]::GetFullPath($repoRoot.Trim())
}

function Get-HooksDirectory {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RepoRoot
    )

    $hooksPathOutput = @(& git -C $RepoRoot rev-parse --git-path hooks 2>$null)
    $exitCode = $LASTEXITCODE
    $hooksPath = ($hooksPathOutput | Select-Object -First 1)
    if ($exitCode -ne 0 -or [string]::IsNullOrWhiteSpace($hooksPath)) {
        throw "Unable to resolve the Git hooks directory for '$RepoRoot'."
    }

    [System.IO.Path]::GetFullPath((Join-Path $RepoRoot $hooksPath.Trim()))
}

$repoRootPath = Resolve-RepoRoot -Candidate $RepoRoot
$toolingRoot = Split-Path -Parent $PSScriptRoot
$hookRunnerPath = Join-Path $toolingRoot 'helpers\git-pre-commit-editorconfig.ps1'
$hooksDir = Get-HooksDirectory -RepoRoot $repoRootPath
$preCommitPath = Join-Path $hooksDir 'pre-commit'

if (-not (Test-Path -LiteralPath $hookRunnerPath -PathType Leaf)) {
    throw "Missing hook runner: $hookRunnerPath"
}

if (-not (Test-Path -LiteralPath $hooksDir -PathType Container)) {
    $null = New-Item -ItemType Directory -Path $hooksDir -Force
}

$relativeHookRunnerPath = [System.IO.Path]::GetRelativePath($repoRootPath, $hookRunnerPath).Replace('\', '/')
$marker = '# eMule-tooling editorconfig hook'

if ((Test-Path -LiteralPath $preCommitPath -PathType Leaf) -and -not $Force) {
    $existingContent = Get-Content -Raw -LiteralPath $preCommitPath
    if ($existingContent -notmatch [regex]::Escape($marker)) {
        throw "Refusing to overwrite an existing unmanaged pre-commit hook at '$preCommitPath'. Use -Force to replace it."
    }
}

$hookContent = @(
    '#!/bin/sh'
    $marker
    'repo_root=$(git rev-parse --show-toplevel 2>/dev/null) || exit 1'
    "hook_runner=`"`$repo_root/$relativeHookRunnerPath`""
    'if command -v pwsh >/dev/null 2>&1; then'
    '  exec pwsh -NoLogo -NoProfile -ExecutionPolicy Bypass -File "$hook_runner" -RepoRoot "$repo_root"'
    'fi'
    'exec powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "$hook_runner" -RepoRoot "$repo_root"'
) -join "`n"

[System.IO.File]::WriteAllText($preCommitPath, "$hookContent`n", [System.Text.UTF8Encoding]::new($false))
Write-Host ("Installed editorconfig pre-commit hook for {0}" -f $repoRootPath) -ForegroundColor Green
Write-Host ("Hook path: {0}" -f $preCommitPath)
