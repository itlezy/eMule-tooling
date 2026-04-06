#Requires -Version 7.2
<#
.SYNOPSIS
Fails when tracked files contain local user-home paths or configured personal identifier leaks.

.PARAMETER RepoRoot
The root of the tracked repository to scan.

.PARAMETER PolicyPath
The JSON policy file that defines the tracked-file privacy rules.

.PARAMETER SummaryPath
Optional path that receives the machine-readable guard summary.
#>
[CmdletBinding()]
param(
    [string]$RepoRoot = (Split-Path -Parent $PSScriptRoot),

    [string]$PolicyPath = (Join-Path (Split-Path -Parent $PSScriptRoot) 'manifests\privacy-guard\policy.v1.json'),

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

function Get-PersonalIdentifiers {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RepoRoot
    )

    $candidates = New-Object System.Collections.Generic.List[string]
    $profileLeafCandidates = @()
    foreach ($profilePath in @($env:USERPROFILE, $env:HOME)) {
        if (-not [string]::IsNullOrWhiteSpace($profilePath)) {
            $profileLeafCandidates += (Split-Path -Leaf $profilePath)
        }
    }

    foreach ($value in @(
        $env:USERNAME,
        $env:USER
    ) + $profileLeafCandidates) {
        if (-not [string]::IsNullOrWhiteSpace($value)) {
            $candidates.Add($value)
        }
    }

    foreach ($value in @($env:TRACKED_FILE_PRIVACY_IDENTIFIERS -split '[,;]')) {
        if (-not [string]::IsNullOrWhiteSpace($value)) {
            $candidates.Add($value.Trim())
        }
    }

    $localIdentifierPath = Join-Path $RepoRoot '.tracked-file-privacy-identifiers.local.json'
    if (Test-Path -LiteralPath $localIdentifierPath -PathType Leaf) {
        $localPolicy = Get-Content -Raw -LiteralPath $localIdentifierPath | ConvertFrom-Json -AsHashtable
        foreach ($value in @($localPolicy.personalIdentifiers)) {
            if (-not [string]::IsNullOrWhiteSpace($value)) {
                $candidates.Add([string]$value)
            }
        }
    }

    $normalized = $candidates |
        ForEach-Object { $_.Trim().ToLowerInvariant() } |
        Where-Object { $_ -match '^[a-z0-9][a-z0-9._-]{2,}$' } |
        Select-Object -Unique

    return @($normalized)
}

function Get-DynamicPathRules {
    param(
        $PersonalIdentifiers
    )

    $rules = New-Object System.Collections.Generic.List[object]
    foreach ($identifier in $PersonalIdentifiers) {
        $normalizedIdentifier = [string]$identifier
        if ([string]::IsNullOrWhiteSpace($normalizedIdentifier)) {
            continue
        }

        $rules.Add([pscustomobject]@{
            id = 'personal-identifier-filename'
            reason = 'Tracked filenames must not embed configured or environment-derived personal identifiers.'
            regex = ("(^|[\\\\/])[^\\\\/]*{0}[^\\\\/]*$" -f [regex]::Escape($normalizedIdentifier))
        })
    }

    return $rules.ToArray()
}

function Test-PathExcluded {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RelativePath,

        [Parameter(Mandatory = $true)]
        $ExcludedPathRegexes
    )

    foreach ($regex in $ExcludedPathRegexes) {
        if ($RelativePath -match $regex) {
            return $true
        }
    }

    return $false
}

function Test-RelativePathAgainstRules {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RelativePath,

        [Parameter(Mandatory = $true)]
        $Rules
    )

    foreach ($rule in $Rules) {
        if ($RelativePath -match $rule.regex) {
            return [pscustomobject]@{
                matched = $true
                rule = $rule.id
                reason = $rule.reason
                regex = $rule.regex
            }
        }
    }

    return [pscustomobject]@{
        matched = $false
        rule = $null
        reason = $null
        regex = $null
    }
}

$repoRootPath = (Resolve-Path -LiteralPath $RepoRoot).Path
if (-not (Test-Path -LiteralPath $PolicyPath -PathType Leaf)) {
    throw "Privacy-guard policy not found at '$PolicyPath'."
}

$policy = Get-Content -Raw -LiteralPath $PolicyPath | ConvertFrom-Json -AsHashtable
$excludedPathRegexes = @($policy.excludedPathRegexes)
$personalIdentifiers = @(Get-PersonalIdentifiers -RepoRoot $repoRootPath)
$dynamicPathRules = @(Get-DynamicPathRules -PersonalIdentifiers $personalIdentifiers)
$pathRules = @($policy.pathRules) + $dynamicPathRules
$trackedFiles = Get-TrackedFiles -RepoRoot $repoRootPath
$scannedTrackedFiles = New-Object System.Collections.Generic.List[string]
$excludedTrackedFiles = New-Object System.Collections.Generic.List[string]
$pathMatches = New-Object System.Collections.Generic.List[object]

foreach ($relativePath in $trackedFiles) {
    if (Test-PathExcluded -RelativePath $relativePath -ExcludedPathRegexes $excludedPathRegexes) {
        $excludedTrackedFiles.Add($relativePath)
        continue
    }

    $scannedTrackedFiles.Add($relativePath)
    $pathResult = Test-RelativePathAgainstRules -RelativePath $relativePath -Rules $pathRules
    if ($pathResult.matched) {
        $pathMatches.Add([pscustomobject]@{
            path = $relativePath
            rule = $pathResult.rule
            reason = $pathResult.reason
            regex = $pathResult.regex
        })
    }
}

$contentMatches = New-Object System.Collections.Generic.List[object]
if ($scannedTrackedFiles.Count -gt 0) {
    foreach ($rule in @($policy.contentRules)) {
        $output = & git -C $repoRootPath grep -n -I -E -- $rule.regex -- $scannedTrackedFiles.ToArray() 2>$null
        if ($LASTEXITCODE -eq 0 -and $output) {
            foreach ($line in @($output)) {
                $parts = $line -split ':', 3
                $relativePath = if ($parts.Count -gt 0) { $parts[0] } else { '' }
                $lineNumber = if ($parts.Count -gt 1) { $parts[1] } else { '' }
                $preview = if ($parts.Count -gt 2) { $parts[2] } else { '' }
                $contentMatches.Add([pscustomobject]@{
                    rule = $rule.id
                    reason = $rule.reason
                    path = $relativePath
                    line = $lineNumber
                    preview = $preview
                })
            }
        }
    }
}

$summary = [pscustomobject]@{
    schemaVersion = 'tracked-file-privacy-guard-summary/v1'
    repoRoot = $repoRootPath
    policyVersion = $policy.policyVersion
    personalIdentifierRuleCount = $dynamicPathRules.Count
    scannedTrackedFiles = $scannedTrackedFiles.Count
    excludedTrackedFiles = $excludedTrackedFiles.ToArray()
    pathMatches = $pathMatches.ToArray()
    contentMatches = $contentMatches.ToArray()
    passed = ($pathMatches.Count -eq 0 -and $contentMatches.Count -eq 0)
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
    throw 'Tracked-file privacy guard failed.'
}

exit 0
