#Requires -Version 7.6
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

function Resolve-PathLikeGit {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RepoRoot,
        [Parameter(Mandatory = $true)]
        [string]$PathValue
    )

    if ([System.IO.Path]::IsPathRooted($PathValue)) {
        return [System.IO.Path]::GetFullPath($PathValue)
    }

    return [System.IO.Path]::GetFullPath((Join-Path $RepoRoot $PathValue))
}

function Get-GitPath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RepoRoot,
        [Parameter(Mandatory = $true)]
        [string]$GitPath
    )

    $gitPathOutput = @(& git -C $RepoRoot rev-parse --git-path $GitPath 2>$null)
    $exitCode = $LASTEXITCODE
    $resolvedPath = ($gitPathOutput | Select-Object -First 1)
    if ($exitCode -ne 0 -or [string]::IsNullOrWhiteSpace($resolvedPath)) {
        throw "Unable to resolve Git path '$GitPath' for '$RepoRoot'."
    }

    return Resolve-PathLikeGit -RepoRoot $RepoRoot -PathValue $resolvedPath.Trim()
}

function Get-LocalHooksPathSetting {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RepoRoot
    )

    $hooksPathOutput = @(& git -C $RepoRoot config --local --get core.hooksPath 2>$null)
    $exitCode = $LASTEXITCODE
    if ($exitCode -ne 0) {
        return ''
    }

    return (($hooksPathOutput | Select-Object -First 1) ?? '').Trim()
}

$repoRootPath = Resolve-RepoRoot -Candidate $RepoRoot
$toolingRoot = Split-Path -Parent $PSScriptRoot
$sharedHooksDir = [System.IO.Path]::GetFullPath((Join-Path $toolingRoot 'hooks'))
$sharedPreCommitPath = Join-Path $sharedHooksDir 'pre-commit'
$marker = '# eMule-tooling editorconfig hook'

if (-not (Test-Path -LiteralPath $sharedPreCommitPath -PathType Leaf)) {
    throw "Missing shared pre-commit hook: $sharedPreCommitPath"
}

$configuredHooksPath = Get-LocalHooksPathSetting -RepoRoot $repoRootPath
$configuredHooksPathResolved = ''
if (-not [string]::IsNullOrWhiteSpace($configuredHooksPath)) {
    $configuredHooksPathResolved = Resolve-PathLikeGit -RepoRoot $repoRootPath -PathValue $configuredHooksPath
}

if (-not [string]::IsNullOrWhiteSpace($configuredHooksPathResolved) -and
    $configuredHooksPathResolved -ne $sharedHooksDir -and
    -not $Force) {
    throw "Refusing to replace an existing unmanaged core.hooksPath for '$repoRootPath'. Use -Force to replace it."
}

$effectiveHooksDir = Get-GitPath -RepoRoot $repoRootPath -GitPath 'hooks'
$existingPreCommitPath = Join-Path $effectiveHooksDir 'pre-commit'
if ((Test-Path -LiteralPath $existingPreCommitPath -PathType Leaf) -and
    $existingPreCommitPath -ne $sharedPreCommitPath -and
    [string]::IsNullOrWhiteSpace($configuredHooksPathResolved) -and
    -not $Force) {
    $existingContent = Get-Content -Raw -LiteralPath $existingPreCommitPath
    if ($existingContent -notmatch [regex]::Escape($marker)) {
        throw "Refusing to replace an existing unmanaged pre-commit hook at '$existingPreCommitPath'. Use -Force to replace it."
    }
}

& git -C $repoRootPath config --local core.hooksPath $sharedHooksDir
if ($LASTEXITCODE -ne 0) {
    throw "Failed to configure core.hooksPath for '$repoRootPath'."
}

& git -C $repoRootPath config --local core.autocrlf false
if ($LASTEXITCODE -ne 0) {
    throw "Failed to configure core.autocrlf for '$repoRootPath'."
}

if ((Test-Path -LiteralPath $existingPreCommitPath -PathType Leaf) -and
    $existingPreCommitPath -ne $sharedPreCommitPath -and
    [string]::IsNullOrWhiteSpace($configuredHooksPathResolved)) {
    $existingContent = Get-Content -Raw -LiteralPath $existingPreCommitPath
    if ($existingContent -match [regex]::Escape($marker)) {
        Remove-Item -LiteralPath $existingPreCommitPath -Force
    }
}

$installedHooksDir = Get-GitPath -RepoRoot $repoRootPath -GitPath 'hooks'
Write-Host ("Configured editorconfig hook for {0}" -f $repoRootPath) -ForegroundColor Green
Write-Host ("core.hooksPath: {0}" -f $installedHooksDir)
Write-Host 'core.autocrlf: false'
