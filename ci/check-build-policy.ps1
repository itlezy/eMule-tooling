#Requires -Version 7.2
[CmdletBinding()]
param(
    [string]$EmuleWorkspaceRoot
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

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

function Get-ProjectXml([string]$RelativePath) {
    $path = Resolve-WorkspacePath $RelativePath
    if (-not (Test-Path -LiteralPath $path)) {
        throw "Required project file not found: $path"
    }

    [xml](Get-Content -LiteralPath $path)
}

function Get-PropertyGroupByCondition($ProjectXml, [string]$Condition) {
    @(
        $ProjectXml.Project.PropertyGroup |
            Where-Object { $_.PSObject.Properties.Match('Condition').Count -gt 0 -and $_.Condition -eq $Condition }
    ) | Select-Object -First 1
}

function Get-ItemDefinitionGroupByCondition($ProjectXml, [string]$Condition) {
    @(
        $ProjectXml.Project.ItemDefinitionGroup |
            Where-Object { $_.PSObject.Properties.Match('Condition').Count -gt 0 -and $_.Condition -eq $Condition }
    ) | Select-Object -First 1
}

function Assert-Value([string]$ProjectLabel, [string]$Condition, [string]$PropertyName, $ActualValue, [string]$ExpectedValue) {
    if ([string]::IsNullOrWhiteSpace([string]$ActualValue)) {
        throw "$ProjectLabel is missing $PropertyName for $Condition"
    }
    if ([string]$ActualValue -ne $ExpectedValue) {
        throw "$ProjectLabel has $PropertyName=$ActualValue for $Condition, expected $ExpectedValue"
    }
}

function Assert-PropertyGroupValue($ProjectXml, [string]$ProjectLabel, [string]$Condition, [string]$PropertyName, [string]$ExpectedValue) {
    $group = Get-PropertyGroupByCondition $ProjectXml $Condition
    if (-not $group) {
        throw "$ProjectLabel is missing PropertyGroup for $Condition"
    }

    Assert-Value $ProjectLabel $Condition $PropertyName $group.$PropertyName $ExpectedValue
}

function Assert-ClCompileValue($ProjectXml, [string]$ProjectLabel, [string]$Condition, [string]$PropertyName, [string]$ExpectedValue) {
    $group = Get-ItemDefinitionGroupByCondition $ProjectXml $Condition
    if (-not $group -or -not $group.ClCompile) {
        throw "$ProjectLabel is missing ClCompile settings for $Condition"
    }

    Assert-Value $ProjectLabel $Condition $PropertyName $group.ClCompile.$PropertyName $ExpectedValue
}

$appDebugCondition = "'`$(Configuration)'=='Debug'"
$appReleaseCondition = "'`$(Configuration)'=='Release'"
$testsDebugCondition = "'`$(Configuration)|`$(Platform)'=='Debug|x64'"
$testsReleaseCondition = "'`$(Configuration)|`$(Platform)'=='Release|x64'"
$testsBootstrapCondition = "'`$(Configuration)'=='Debug' or '`$(Configuration)'=='_SpecialBootstrapNodes'"
$id3libDebugX64Condition = "'`$(Configuration)|`$(Platform)'=='Debug|x64'"
$id3libDebugArm64Condition = "'`$(Configuration)|`$(Platform)'=='Debug|ARM64'"
$id3libReleaseX64Condition = "'`$(Configuration)|`$(Platform)'=='Release|x64'"
$id3libReleaseArm64Condition = "'`$(Configuration)|`$(Platform)'=='Release|ARM64'"
$resizableDebugX64Condition = "'`$(Configuration)|`$(Platform)'=='Debug|x64'"
$resizableDebugArm64Condition = "'`$(Configuration)|`$(Platform)'=='Debug|ARM64'"
$resizableReleaseX64Condition = "'`$(Configuration)|`$(Platform)'=='Release|x64'"
$resizableReleaseArm64Condition = "'`$(Configuration)|`$(Platform)'=='Release|ARM64'"
$miniupnpDebugX64Condition = "'`$(Configuration)|`$(Platform)'=='Debug|x64'"
$miniupnpDebugArm64Condition = "'`$(Configuration)|`$(Platform)'=='Debug|ARM64'"
$miniupnpReleaseX64Condition = "'`$(Configuration)|`$(Platform)'=='Release|x64'"
$miniupnpReleaseArm64Condition = "'`$(Configuration)|`$(Platform)'=='Release|ARM64'"

$appXml = Get-ProjectXml 'workspaces\v0.72a\app\eMule-main\srchybrid\emule.vcxproj'
Assert-ClCompileValue $appXml 'emule.vcxproj' $appDebugCondition 'LanguageStandard' 'stdcpp17'
Assert-ClCompileValue $appXml 'emule.vcxproj' $appDebugCondition 'Optimization' 'Disabled'
Assert-ClCompileValue $appXml 'emule.vcxproj' $appDebugCondition 'RuntimeLibrary' 'MultiThreadedDebug'
Assert-ClCompileValue $appXml 'emule.vcxproj' $appReleaseCondition 'LanguageStandard' 'stdcpp17'
Assert-ClCompileValue $appXml 'emule.vcxproj' $appReleaseCondition 'Optimization' 'MaxSpeed'
Assert-ClCompileValue $appXml 'emule.vcxproj' $appReleaseCondition 'RuntimeLibrary' 'MultiThreaded'
Assert-ClCompileValue $appXml 'emule.vcxproj' $appReleaseCondition 'FunctionLevelLinking' 'true'
Assert-ClCompileValue $appXml 'emule.vcxproj' $appReleaseCondition 'IntrinsicFunctions' 'true'

$testsXml = Get-ProjectXml 'repos\eMule-build-tests\emule-tests.vcxproj'
Assert-PropertyGroupValue $testsXml 'emule-tests.vcxproj' $testsDebugCondition 'PlatformToolset' 'v143'
Assert-PropertyGroupValue $testsXml 'emule-tests.vcxproj' $testsReleaseCondition 'PlatformToolset' 'v143'
Assert-ClCompileValue $testsXml 'emule-tests.vcxproj' $testsBootstrapCondition 'LanguageStandard' 'stdcpp17'
Assert-ClCompileValue $testsXml 'emule-tests.vcxproj' $testsBootstrapCondition 'Optimization' 'Disabled'
Assert-ClCompileValue $testsXml 'emule-tests.vcxproj' $testsBootstrapCondition 'RuntimeLibrary' 'MultiThreadedDebug'
Assert-ClCompileValue $testsXml 'emule-tests.vcxproj' $appReleaseCondition 'LanguageStandard' 'stdcpp17'
Assert-ClCompileValue $testsXml 'emule-tests.vcxproj' $appReleaseCondition 'Optimization' 'MaxSpeed'
Assert-ClCompileValue $testsXml 'emule-tests.vcxproj' $appReleaseCondition 'RuntimeLibrary' 'MultiThreaded'
Assert-ClCompileValue $testsXml 'emule-tests.vcxproj' $appReleaseCondition 'FunctionLevelLinking' 'true'
Assert-ClCompileValue $testsXml 'emule-tests.vcxproj' $appReleaseCondition 'IntrinsicFunctions' 'true'

$id3libXml = Get-ProjectXml 'repos\third_party\eMule-id3lib\libprj\id3lib.vcxproj'
foreach ($condition in @($id3libDebugX64Condition, $id3libDebugArm64Condition)) {
    Assert-ClCompileValue $id3libXml 'id3lib.vcxproj' $condition 'LanguageStandard' 'stdcpp17'
    Assert-ClCompileValue $id3libXml 'id3lib.vcxproj' $condition 'Optimization' 'Disabled'
    Assert-ClCompileValue $id3libXml 'id3lib.vcxproj' $condition 'RuntimeLibrary' 'MultiThreadedDebug'
}
foreach ($condition in @($id3libReleaseX64Condition, $id3libReleaseArm64Condition)) {
    Assert-ClCompileValue $id3libXml 'id3lib.vcxproj' $condition 'LanguageStandard' 'stdcpp17'
    Assert-ClCompileValue $id3libXml 'id3lib.vcxproj' $condition 'RuntimeLibrary' 'MultiThreaded'
    Assert-ClCompileValue $id3libXml 'id3lib.vcxproj' $condition 'FunctionLevelLinking' 'true'
    Assert-ClCompileValue $id3libXml 'id3lib.vcxproj' $condition 'IntrinsicFunctions' 'true'
    Assert-ClCompileValue $id3libXml 'id3lib.vcxproj' $condition 'WholeProgramOptimization' 'true'
}

$resizableXml = Get-ProjectXml 'repos\third_party\eMule-ResizableLib\ResizableLib\ResizableLib.vcxproj'
foreach ($condition in @($resizableDebugX64Condition, $resizableDebugArm64Condition)) {
    Assert-ClCompileValue $resizableXml 'ResizableLib.vcxproj' $condition 'LanguageStandard' 'stdcpp17'
    Assert-ClCompileValue $resizableXml 'ResizableLib.vcxproj' $condition 'Optimization' 'Disabled'
    Assert-ClCompileValue $resizableXml 'ResizableLib.vcxproj' $condition 'RuntimeLibrary' 'MultiThreadedDebug'
}
foreach ($condition in @($resizableReleaseX64Condition, $resizableReleaseArm64Condition)) {
    Assert-ClCompileValue $resizableXml 'ResizableLib.vcxproj' $condition 'LanguageStandard' 'stdcpp17'
    Assert-ClCompileValue $resizableXml 'ResizableLib.vcxproj' $condition 'Optimization' 'MaxSpeed'
    Assert-ClCompileValue $resizableXml 'ResizableLib.vcxproj' $condition 'RuntimeLibrary' 'MultiThreaded'
    Assert-ClCompileValue $resizableXml 'ResizableLib.vcxproj' $condition 'FunctionLevelLinking' 'true'
}

$miniupnpXml = Get-ProjectXml 'repos\third_party\eMule-miniupnp\miniupnpc\msvc\miniupnpc.vcxproj'
foreach ($condition in @($miniupnpDebugX64Condition, $miniupnpDebugArm64Condition)) {
    Assert-ClCompileValue $miniupnpXml 'miniupnpc.vcxproj' $condition 'Optimization' 'Disabled'
    Assert-ClCompileValue $miniupnpXml 'miniupnpc.vcxproj' $condition 'RuntimeLibrary' 'MultiThreadedDebug'
}
foreach ($condition in @($miniupnpReleaseX64Condition, $miniupnpReleaseArm64Condition)) {
    Assert-ClCompileValue $miniupnpXml 'miniupnpc.vcxproj' $condition 'Optimization' 'MaxSpeed'
    Assert-ClCompileValue $miniupnpXml 'miniupnpc.vcxproj' $condition 'RuntimeLibrary' 'MultiThreaded'
    Assert-ClCompileValue $miniupnpXml 'miniupnpc.vcxproj' $condition 'FunctionLevelLinking' 'true'
    Assert-ClCompileValue $miniupnpXml 'miniupnpc.vcxproj' $condition 'IntrinsicFunctions' 'true'
}

Write-Host 'Active build policy audit passed.'
