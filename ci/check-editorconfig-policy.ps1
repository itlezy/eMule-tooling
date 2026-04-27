#Requires -Version 7.6
[CmdletBinding()]
param(
    [string]$EmuleWorkspaceRoot,

    [string]$SetupRepoRoot = ''
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
$toolingRepoRoot = [System.IO.Path]::GetFullPath((Join-Path $EmuleWorkspaceRoot 'repos\eMule-tooling'))
$normalizerPath = Join-Path $toolingRepoRoot 'helpers\source-normalizer.py'

if ([string]::IsNullOrWhiteSpace($SetupRepoRoot)) {
    $candidateSetupRoot = [System.IO.Path]::GetFullPath((Join-Path (Split-Path -Parent $EmuleWorkspaceRoot) 'eMulebb-setup'))
    if (Test-Path -LiteralPath $candidateSetupRoot -PathType Container) {
        $SetupRepoRoot = $candidateSetupRoot
    }
} else {
    $SetupRepoRoot = [System.IO.Path]::GetFullPath($SetupRepoRoot)
}

function Resolve-WorkspacePath([string]$RelativePath) {
    [System.IO.Path]::GetFullPath((Join-Path $EmuleWorkspaceRoot $RelativePath))
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

    throw 'python.exe or py.exe is required for the editorconfig policy audit.'
}

function Invoke-NormalizerCheck {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RepoRoot,

        [Parameter(Mandatory = $true)]
        [string]$Label,

        [string[]]$Paths = @(),

        [Parameter(Mandatory = $true)]
        $PythonCommand
    )

    if (-not (Test-Path -LiteralPath $RepoRoot -PathType Container)) {
        throw "Editorconfig audit root is missing: $RepoRoot"
    }

    $pathsToCheck = @($Paths | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
    if ($pathsToCheck.Count -eq 0) {
        Write-Host ("Editorconfig audit: {0} (no modified tracked files)" -f $Label) -ForegroundColor DarkGray
        return
    }

    Write-Host ("Editorconfig audit: {0}" -f $Label) -ForegroundColor Green
    & $PythonCommand.FilePath @($PythonCommand.PrefixArguments + @(
        $normalizerPath,
        '--root',
        $RepoRoot,
        '--check'
    ) + $pathsToCheck)
    if ($LASTEXITCODE -ne 0) {
        throw "Editorconfig audit failed for '$Label'."
    }
}

function Get-ModifiedTrackedPaths {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RepoRoot
    )

    $candidatePaths = New-Object System.Collections.Generic.HashSet[string]
    foreach ($argumentList in @(
        @('diff', '--name-only', '--diff-filter=ACMRT'),
        @('diff', '--cached', '--name-only', '--diff-filter=ACMRT')
    )) {
        $output = @(& git -C $RepoRoot @argumentList 2>$null)
        $exitCode = $LASTEXITCODE
        if ($exitCode -ne 0) {
            throw "git $($argumentList -join ' ') failed for '$RepoRoot'."
        }

        foreach ($path in @($output | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })) {
            $candidatePaths.Add($path.Trim()) | Out-Null
        }
    }

    @($candidatePaths | Sort-Object)
}

if (-not (Test-Path -LiteralPath $normalizerPath -PathType Leaf)) {
    throw "Missing source normalizer: $normalizerPath"
}

$pythonCommand = Get-PythonCommand
$scopes = @(
    @{ Label = 'tooling'; RepoRoot = Resolve-WorkspacePath 'repos\eMule-tooling' }
    @{ Label = 'setup'; RepoRoot = $SetupRepoRoot }
    @{ Label = 'build'; RepoRoot = Resolve-WorkspacePath 'repos\eMule-build' }
    @{ Label = 'tests'; RepoRoot = Resolve-WorkspacePath 'repos\eMule-build-tests' }
    @{ Label = 'remote'; RepoRoot = Resolve-WorkspacePath 'repos\eMule-remote' }
    @{ Label = 'app-main'; RepoRoot = Resolve-WorkspacePath 'workspaces\v0.72a\app\eMule-main' }
    @{ Label = 'app-community'; RepoRoot = Resolve-WorkspacePath 'workspaces\v0.72a\app\eMule-v0.72a-community' }
    @{ Label = 'app-broadband'; RepoRoot = Resolve-WorkspacePath 'workspaces\v0.72a\app\eMule-v0.72a-broadband' }
    @{ Label = 'app-tracing-harness'; RepoRoot = Resolve-WorkspacePath 'workspaces\v0.72a\app\eMule-v0.72a-tracing-harness-community' }
)

foreach ($scope in $scopes) {
    if ([string]::IsNullOrWhiteSpace($scope.RepoRoot)) {
        continue
    }
    $modifiedPaths = Get-ModifiedTrackedPaths -RepoRoot $scope.RepoRoot
    Invoke-NormalizerCheck -RepoRoot $scope.RepoRoot -Label $scope.Label -Paths $modifiedPaths -PythonCommand $pythonCommand
}

Write-Host 'Editorconfig policy audit passed.'
