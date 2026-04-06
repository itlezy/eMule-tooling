#Requires -Version 7.2
<#
.SYNOPSIS
Runs cheap cross-repo hygiene checks against tracked files.

.PARAMETER RepoRoot
The tracked repository to scan.

.PARAMETER RepoKind
Optional repo kind hint. Supported values are generic, workspace, app, tests,
tooling, and node-web.

.PARAMETER SummaryPath
Optional path that receives the machine-readable summary.
#>
[CmdletBinding()]
param(
    [string]$RepoRoot = (Split-Path -Parent $PSScriptRoot),

    [ValidateSet('generic', 'workspace', 'app', 'tests', 'tooling', 'node-web')]
    [string]$RepoKind = 'generic',

    [string]$SummaryPath = ''
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $false

function Get-TrackedFiles {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RepoRoot
    )

    $output = & git -C $RepoRoot ls-files -z
    if ($LASTEXITCODE -ne 0) {
        throw "git ls-files failed for '$RepoRoot'."
    }

    return @($output -split "`0" | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
}

function Add-Issue {
    param(
        [Parameter(Mandatory = $true)]
        $Issues,

        [Parameter(Mandatory = $true)]
        [string]$Kind,

        [Parameter(Mandatory = $true)]
        [string]$Path,

        [Parameter(Mandatory = $true)]
        [string]$Reason
    )

    $Issues.Add([pscustomobject]@{
        kind = $Kind
        path = $Path
        reason = $Reason
    })
}

function Test-PowerShellSyntax {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $tokens = $null
    $errors = $null
    [void][System.Management.Automation.Language.Parser]::ParseFile($Path, [ref]$tokens, [ref]$errors)
    return @($errors)
}

function Test-YamlTextShape {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $content = Get-Content -Raw -LiteralPath $Path
    if ([string]::IsNullOrWhiteSpace($content)) {
        return 'YAML file is empty.'
    }

    if ($content -match "`t") {
        return 'YAML file contains tab indentation.'
    }

    $trimmed = $content.Trim()
    if ($trimmed -notmatch '(^|\r?\n)(name|on|jobs|defaults|env)\s*:') {
        return 'YAML file does not contain an obvious top-level mapping key.'
    }

    return $null
}

$repoRootPath = (Resolve-Path -LiteralPath $RepoRoot).Path
$trackedFiles = Get-TrackedFiles -RepoRoot $repoRootPath
$issues = New-Object System.Collections.Generic.List[object]
$summaryCounts = [ordered]@{
    json = 0
    yaml = 0
    powershell = 0
    psd1 = 0
}

foreach ($relativePath in $trackedFiles) {
    $fullPath = Join-Path $repoRootPath $relativePath
    if (-not (Test-Path -LiteralPath $fullPath -PathType Leaf)) {
        continue
    }

    switch -Regex ($relativePath) {
        '\.json$' {
            $summaryCounts.json++
            try {
                $null = Get-Content -Raw -LiteralPath $fullPath | ConvertFrom-Json -AsHashtable
            } catch {
                Add-Issue -Issues $issues -Kind 'json-parse' -Path $relativePath -Reason $_.Exception.Message
            }
            continue
        }
        '\.(yml|yaml)$' {
            $summaryCounts.yaml++
            $yamlIssue = Test-YamlTextShape -Path $fullPath
            if ($yamlIssue) {
                Add-Issue -Issues $issues -Kind 'yaml-shape' -Path $relativePath -Reason $yamlIssue
            }
            continue
        }
        '\.ps1$' {
            $summaryCounts.powershell++
            $errors = Test-PowerShellSyntax -Path $fullPath
            foreach ($error in $errors) {
                Add-Issue -Issues $issues -Kind 'powershell-parse' -Path $relativePath -Reason $error.Message
            }
            continue
        }
        '\.psd1$' {
            $summaryCounts.psd1++
            try {
                $null = Import-PowerShellDataFile -LiteralPath $fullPath
            } catch {
                Add-Issue -Issues $issues -Kind 'psd1-parse' -Path $relativePath -Reason $_.Exception.Message
            }
            continue
        }
    }
}

if ($RepoKind -eq 'node-web') {
    $packageJsonPath = Join-Path $repoRootPath 'package.json'
    if (Test-Path -LiteralPath $packageJsonPath -PathType Leaf) {
        $packageJson = Get-Content -Raw -LiteralPath $packageJsonPath | ConvertFrom-Json -AsHashtable
        foreach ($requiredScriptName in @('build', 'test')) {
            if (-not $packageJson.scripts.ContainsKey($requiredScriptName)) {
                Add-Issue -Issues $issues -Kind 'node-script' -Path 'package.json' -Reason "Missing npm script '$requiredScriptName'."
            }
        }
    } else {
        Add-Issue -Issues $issues -Kind 'node-package' -Path 'package.json' -Reason 'Node web repo is missing package.json.'
    }
}

$summary = [pscustomobject]@{
    schemaVersion = 'basic-hygiene-summary/v1'
    repoRoot = $repoRootPath
    repoKind = $RepoKind
    checked = $summaryCounts
    issues = $issues.ToArray()
    passed = ($issues.Count -eq 0)
}

$summaryJson = $summary | ConvertTo-Json -Depth 8
if (-not [string]::IsNullOrWhiteSpace($SummaryPath)) {
    $summaryDirectory = Split-Path -Parent $SummaryPath
    if (-not [string]::IsNullOrWhiteSpace($summaryDirectory)) {
        $null = New-Item -ItemType Directory -Force -Path $summaryDirectory
    }

    $summaryJson | Set-Content -LiteralPath $SummaryPath -Encoding utf8
}

Write-Output $summaryJson

if (-not $summary.passed) {
    throw 'Basic hygiene checks failed.'
}

exit 0
