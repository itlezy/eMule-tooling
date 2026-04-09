#Requires -Version 7.2
[CmdletBinding()]
param(
    [string]$RepoRoot = ''
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $false

function Resolve-RepoRoot {
    param(
        [string]$Candidate
    )

    if (-not [string]::IsNullOrWhiteSpace($Candidate)) {
        return [System.IO.Path]::GetFullPath($Candidate)
    }

    $repoRoot = (& git rev-parse --show-toplevel 2>$null | Select-Object -First 1)
    if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($repoRoot)) {
        throw 'Unable to resolve the Git repo root for the editorconfig hook.'
    }

    return [System.IO.Path]::GetFullPath($repoRoot.Trim())
}

function Get-PythonCommand {
    foreach ($name in @('python.exe', 'python', 'py.exe', 'py')) {
        $command = Get-Command $name -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($command) {
            if ($command.Name -match '^py(\.exe)?$') {
                return [pscustomobject]@{
                    FilePath = $command.Source
                    PrefixArguments = @('-3')
                }
            }

            return [pscustomobject]@{
                FilePath = $command.Source
                PrefixArguments = @()
            }
        }
    }

    throw 'python.exe or py.exe is required for the editorconfig pre-commit hook.'
}

$repoRootPath = Resolve-RepoRoot -Candidate $RepoRoot
$normalizerPath = Join-Path (Split-Path -Parent $PSScriptRoot) 'helpers\source-normalizer.py'
if (-not (Test-Path -LiteralPath $normalizerPath -PathType Leaf)) {
    throw "Missing source normalizer: $normalizerPath"
}

$stagedFilesOutput = & git -C $repoRootPath diff --cached --name-only --diff-filter=ACMR -z --
if ($LASTEXITCODE -ne 0) {
    throw "git diff --cached failed for '$repoRootPath'."
}

$stagedFiles = @($stagedFilesOutput -split "`0" | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
if ($stagedFiles.Count -eq 0) {
    exit 0
}

$pythonCommand = Get-PythonCommand
$normalizerOutput = & $pythonCommand.FilePath @($pythonCommand.PrefixArguments + @(
    $normalizerPath,
    '--root',
    $repoRootPath,
    '--write'
) + $stagedFiles) 2>&1
$normalizerExitCode = $LASTEXITCODE

if ($normalizerOutput) {
    $normalizerOutput | ForEach-Object { Write-Host $_ }
}

if ($normalizerExitCode -ne 0) {
    throw 'Editorconfig pre-commit normalization failed.'
}

$rewrittenFiles = @($normalizerOutput | Where-Object { $_ -match '^NORMALIZED:' })
if ($rewrittenFiles.Count -gt 0) {
    Write-Host ''
    Write-Host 'Edited tracked files were normalized to match .editorconfig/.gitattributes.' -ForegroundColor Yellow
    Write-Host 'Review the rewritten files, re-stage them, and retry the commit.' -ForegroundColor Yellow
    exit 1
}

exit 0
