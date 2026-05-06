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

function Invoke-Git([string]$RepoRoot, [string[]]$Arguments) {
    $output = & git -C $RepoRoot @Arguments 2>$null
    $exitCode = $LASTEXITCODE
    [pscustomobject]@{
        ExitCode = $exitCode
        Output = @($output)
    }
}

$scanScopes = @(
    @{
        RepoRoot = Resolve-WorkspacePath 'repos\eMule-tooling'
        Paths = @('README.md', 'AGENTS.md', 'docs\WORKSPACE_POLICY.md', 'docs\RESUME.md')
    }
    @{
        RepoRoot = Resolve-WorkspacePath 'repos\eMule-tooling'
        Paths = @('docs-clean\*.md')
    }
    @{
        RepoRoot = Resolve-WorkspacePath 'repos\eMule-build'
        Paths = @('README.md', 'AGENTS.md')
    }
    @{
        RepoRoot = Resolve-WorkspacePath 'repos\eMule-build-tests'
        Paths = @('README.md', 'AGENTS.md')
    }
    @{
        RepoRoot = Resolve-WorkspacePath 'workspaces\v0.72a\app\eMule-main'
        Paths = @('README.md', 'AGENTS.md')
    }
    @{
        RepoRoot = Resolve-WorkspacePath 'workspaces\v0.72a\app\eMule-v0.72a-community'
        Paths = @('AGENTS.md')
    }
    @{
        RepoRoot = Resolve-WorkspacePath 'workspaces\v0.72a\app\eMule-v0.72a-broadband'
        Paths = @('AGENTS.md')
    }
    @{
        RepoRoot = Resolve-WorkspacePath 'workspaces\v0.72a\app\eMule-v0.72a-tracing-harness-community'
        Paths = @('AGENTS.md')
    }
)

$issues = New-Object System.Collections.Generic.List[string]
$absolutePathRegex = '(?im)\b[a-z]:\\'
$workspacePolicyPathText = 'repos\eMule-tooling\docs\WORKSPACE_POLICY.md'

function Get-TrackedFileText([string]$RepoRoot, [string]$RelativePath) {
    $fullPath = Join-Path $RepoRoot $RelativePath
    if (-not (Test-Path -LiteralPath $fullPath -PathType Leaf)) {
        return $null
    }

    Get-Content -LiteralPath $fullPath -Raw
}

function Assert-TextContains([string]$RepoRoot, [string]$RelativePath, [string]$Needle, [string]$Message) {
    $text = Get-TrackedFileText $RepoRoot $RelativePath
    if ($null -eq $text) {
        $issues.Add(("{0}: missing required file: {1}" -f $RepoRoot, $RelativePath)) | Out-Null
        return
    }

    if ($text -notlike "*$Needle*") {
        $issues.Add(("{0}\{1}: {2}" -f $RepoRoot, $RelativePath, $Message)) | Out-Null
    }
}

function Assert-TextNotContains([string]$RepoRoot, [string]$RelativePath, [string[]]$ForbiddenNeedles, [string]$Message) {
    $text = Get-TrackedFileText $RepoRoot $RelativePath
    if ($null -eq $text) {
        return
    }

    foreach ($needle in $ForbiddenNeedles) {
        if ($text -like "*$needle*") {
            $issues.Add(("{0}\{1}: {2}: {3}" -f $RepoRoot, $RelativePath, $Message, $needle)) | Out-Null
        }
    }
}

function Assert-RestApiContractDefersToOpenApi([string]$RepoRoot) {
    $relativePath = 'docs\REST-API-CONTRACT.md'
    $text = Get-TrackedFileText $RepoRoot $relativePath
    if ($null -eq $text) {
        $issues.Add(("{0}: missing required file: {1}" -f $RepoRoot, $relativePath)) | Out-Null
        return
    }

    if (-not $text.Contains('Source of truth:** [REST-API-OPENAPI.yaml](REST-API-OPENAPI.yaml)', [System.StringComparison]::Ordinal)) {
        $issues.Add(("{0}\{1}: REST contract doc must identify OpenAPI as the source of truth." -f $RepoRoot, $relativePath)) | Out-Null
    }

    $retiredSectionMarker = '## Retired Before Public Release'
    $activeText = $text
    $retiredIndex = $text.IndexOf($retiredSectionMarker, [System.StringComparison]::Ordinal)
    if ($retiredIndex -ge 0) {
        $activeText = $text.Substring(0, $retiredIndex)
    }

    $activeRouteTablePattern = '(?im)^\s*\|.*\b(GET|POST|PATCH|DELETE)\b\s+(/api/v1|/app|/status|/stats|/snapshot|/categories|/transfers|/shared|/uploads|/upload-queue|/servers|/kad|/searches|/friends|/logs)\b'
    $activeRouteListPattern = '(?im)^\s*[-*]\s+`?(GET|POST|PATCH|DELETE)\s+(/api/v1|/app|/status|/stats|/snapshot|/categories|/transfers|/shared|/uploads|/upload-queue|/servers|/kad|/searches|/friends|/logs)\b'
    foreach ($pattern in @($activeRouteTablePattern, $activeRouteListPattern)) {
        $match = [regex]::Match($activeText, $pattern)
        if ($match.Success) {
            $issues.Add(("{0}\{1}: active REST route tables/lists must live in REST-API-OPENAPI.yaml, not the human contract doc: {2}" -f $RepoRoot, $relativePath, $match.Value.Trim())) | Out-Null
        }
    }
}

foreach ($scope in $scanScopes) {
    $repoRoot = [System.IO.Path]::GetFullPath($scope.RepoRoot)
    if (-not (Test-Path -LiteralPath $repoRoot)) {
        throw "Documentation scan root is missing: $repoRoot"
    }

    $lsFiles = Invoke-Git $repoRoot @('ls-files', '--', $scope.Paths)
    if ($lsFiles.ExitCode -ne 0) {
        throw "git ls-files failed for '$repoRoot'."
    }

    foreach ($relativePath in @($lsFiles.Output | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })) {
        $fullPath = Join-Path $repoRoot $relativePath
        if (-not (Test-Path -LiteralPath $fullPath -PathType Leaf)) {
            continue
        }

        $lineNumber = 0
        foreach ($line in Get-Content -LiteralPath $fullPath) {
            $lineNumber++
            if ($line -match $absolutePathRegex) {
                $issues.Add(("{0}:{1}: hardcoded absolute path in markdown: {2}" -f $fullPath, $lineNumber, $line.Trim())) | Out-Null
            }
        }
    }
}

$agentFiles = @(
    @{
        RepoRoot = $EmuleWorkspaceRoot
        Path = 'AGENTS.md'
    }
    @{
        RepoRoot = Resolve-WorkspacePath 'repos\eMule-tooling'
        Path = 'AGENTS.md'
    }
    @{
        RepoRoot = Resolve-WorkspacePath 'repos\eMule-tooling'
        Path = 'scripts\AGENTS.md'
    }
    @{
        RepoRoot = Resolve-WorkspacePath 'repos\eMule-build'
        Path = 'AGENTS.md'
    }
    @{
        RepoRoot = Resolve-WorkspacePath 'repos\eMule-build-tests'
        Path = 'AGENTS.md'
    }
    @{
        RepoRoot = Resolve-WorkspacePath 'workspaces\v0.72a\app\eMule-main'
        Path = 'AGENTS.md'
    }
    @{
        RepoRoot = Resolve-WorkspacePath 'workspaces\v0.72a\app\eMule-v0.72a-community'
        Path = 'AGENTS.md'
    }
    @{
        RepoRoot = Resolve-WorkspacePath 'workspaces\v0.72a\app\eMule-v0.72a-broadband'
        Path = 'AGENTS.md'
    }
    @{
        RepoRoot = Resolve-WorkspacePath 'workspaces\v0.72a\app\eMule-v0.72a-tracing-harness-community'
        Path = 'AGENTS.md'
    }
)

foreach ($agent in $agentFiles) {
    Assert-TextContains $agent.RepoRoot $agent.Path $workspacePolicyPathText 'AGENTS.md must point to the central workspace policy.'
}

$primaryAgentFiles = @(
    @{
        RepoRoot = $EmuleWorkspaceRoot
        Path = 'AGENTS.md'
    }
    @{
        RepoRoot = Resolve-WorkspacePath 'repos\eMule-tooling'
        Path = 'AGENTS.md'
    }
    @{
        RepoRoot = Resolve-WorkspacePath 'repos\eMule-tooling'
        Path = 'scripts\AGENTS.md'
    }
    @{
        RepoRoot = Resolve-WorkspacePath 'repos\eMule-build'
        Path = 'AGENTS.md'
    }
    @{
        RepoRoot = Resolve-WorkspacePath 'repos\eMule-build-tests'
        Path = 'AGENTS.md'
    }
    @{
        RepoRoot = Resolve-WorkspacePath 'workspaces\v0.72a\app\eMule-main'
        Path = 'AGENTS.md'
    }
)

foreach ($agent in $primaryAgentFiles) {
    Assert-TextNotContains $agent.RepoRoot $agent.Path @(
        'the canonical remote repo is `EMULE_WORKSPACE_ROOT\repos\eMule-remote`',
        'community/v0.72a` is the imported baseline'
    ) 'AGENTS.md contains stale workspace directive text'
}

Assert-TextContains (Resolve-WorkspacePath 'repos\eMule-tooling') 'docs\RESUME.md' 'handoff' 'RESUME.md must identify itself as a handoff note.'
Assert-TextContains (Resolve-WorkspacePath 'repos\eMule-tooling') 'docs\RESUME.md' 'not policy' 'RESUME.md must not be usable as policy authority.'

Assert-TextNotContains (Resolve-WorkspacePath 'repos\eMule-tooling') 'README.md' @(
    'repos\eMule-remote',
    'remote companion app'
) 'active tooling README must not reference abandoned eMule-remote entrypoints'

Assert-RestApiContractDefersToOpenApi (Resolve-WorkspacePath 'repos\eMule-tooling')

if ($issues.Count -gt 0) {
    throw ($issues -join [Environment]::NewLine)
}

Write-Host 'Active documentation path audit passed.'
