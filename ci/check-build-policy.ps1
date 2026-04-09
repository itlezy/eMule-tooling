#Requires -Version 7.6
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

function Assert-LinkValue($ProjectXml, [string]$ProjectLabel, [string]$Condition, [string]$PropertyName, [string]$ExpectedValue) {
    $group = Get-ItemDefinitionGroupByCondition $ProjectXml $Condition
    if (-not $group -or -not $group.Link) {
        throw "$ProjectLabel is missing Link settings for $Condition"
    }

    Assert-Value $ProjectLabel $Condition $PropertyName $group.Link.$PropertyName $ExpectedValue
}

function Assert-NoProjectConfigurationPlatform($ProjectXml, [string]$ProjectLabel, [string]$PlatformName) {
    $matches = @()
    foreach ($itemGroup in @($ProjectXml.Project.ItemGroup)) {
        if ($itemGroup.PSObject.Properties.Match('ProjectConfiguration').Count -eq 0) {
            continue
        }

        foreach ($projectConfiguration in @($itemGroup.ProjectConfiguration)) {
            if ($projectConfiguration -and $projectConfiguration.Platform -eq $PlatformName) {
                $matches += $projectConfiguration
            }
        }
    }
    if ($matches.Count -gt 0) {
        throw "$ProjectLabel still declares $PlatformName project configurations"
    }
}

function Assert-NoProjectConfigurationName($ProjectXml, [string]$ProjectLabel, [string]$ConfigurationName) {
    $matches = @()
    foreach ($itemGroup in @($ProjectXml.Project.ItemGroup)) {
        if ($itemGroup.PSObject.Properties.Match('ProjectConfiguration').Count -eq 0) {
            continue
        }

        foreach ($projectConfiguration in @($itemGroup.ProjectConfiguration)) {
            if ($projectConfiguration -and $projectConfiguration.Configuration -eq $ConfigurationName) {
                $matches += $projectConfiguration
            }
        }
    }
    if ($matches.Count -gt 0) {
        throw "$ProjectLabel still declares $ConfigurationName project configurations"
    }
}

$appDebugCondition = "'`$(Configuration)'=='Debug'"
$appReleaseCondition = "'`$(Configuration)'=='Release'"
$testsDebugCondition = "'`$(Configuration)|`$(Platform)'=='Debug|x64'"
$testsReleaseCondition = "'`$(Configuration)|`$(Platform)'=='Release|x64'"
$testsDebugArm64Condition = "'`$(Configuration)|`$(Platform)'=='Debug|ARM64'"
$testsReleaseArm64Condition = "'`$(Configuration)|`$(Platform)'=='Release|ARM64'"
$testsDebugBuildCondition = "'`$(Configuration)'=='Debug'"
$testsReleaseBuildCondition = "'`$(Configuration)'=='Release'"
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
$cryptoppDebugCondition = "'`$(Configuration)'=='Debug' Or '`$(Configuration)'=='DLL-Import Debug'"
$cryptoppReleaseCondition = "'`$(Configuration)'=='Release' Or '`$(Configuration)'=='DLL-Import Release'"

$appXml = Get-ProjectXml 'workspaces\v0.72a\app\eMule-main\srchybrid\emule.vcxproj'
Assert-NoProjectConfigurationPlatform $appXml 'emule.vcxproj' 'Win32'
Assert-NoProjectConfigurationName $appXml 'emule.vcxproj' '_SpecialBootstrapNodes'
Assert-ClCompileValue $appXml 'emule.vcxproj' $appDebugCondition 'LanguageStandard' 'stdcpp17'
Assert-ClCompileValue $appXml 'emule.vcxproj' $appDebugCondition 'Optimization' 'Disabled'
Assert-ClCompileValue $appXml 'emule.vcxproj' $appDebugCondition 'RuntimeLibrary' 'MultiThreadedDebug'
Assert-ClCompileValue $appXml 'emule.vcxproj' $appDebugCondition 'BufferSecurityCheck' 'true'
Assert-ClCompileValue $appXml 'emule.vcxproj' $appDebugCondition 'SDLCheck' 'true'
Assert-ClCompileValue $appXml 'emule.vcxproj' $appDebugCondition 'DebugInformationFormat' 'ProgramDatabase'
Assert-ClCompileValue $appXml 'emule.vcxproj' $appDebugCondition 'MultiProcessorCompilation' 'true'
Assert-ClCompileValue $appXml 'emule.vcxproj' $appDebugCondition 'ControlFlowGuard' 'Guard'
Assert-LinkValue $appXml 'emule.vcxproj' $appDebugCondition 'IncrementalLink' 'true'
Assert-LinkValue $appXml 'emule.vcxproj' $appDebugCondition 'LinkControlFlowGuard' 'true'
Assert-ClCompileValue $appXml 'emule.vcxproj' $appReleaseCondition 'LanguageStandard' 'stdcpp17'
Assert-ClCompileValue $appXml 'emule.vcxproj' $appReleaseCondition 'Optimization' 'MaxSpeed'
Assert-ClCompileValue $appXml 'emule.vcxproj' $appReleaseCondition 'RuntimeLibrary' 'MultiThreaded'
Assert-ClCompileValue $appXml 'emule.vcxproj' $appReleaseCondition 'BufferSecurityCheck' 'true'
Assert-ClCompileValue $appXml 'emule.vcxproj' $appReleaseCondition 'SDLCheck' 'true'
Assert-ClCompileValue $appXml 'emule.vcxproj' $appReleaseCondition 'FunctionLevelLinking' 'true'
Assert-ClCompileValue $appXml 'emule.vcxproj' $appReleaseCondition 'IntrinsicFunctions' 'true'
Assert-ClCompileValue $appXml 'emule.vcxproj' $appReleaseCondition 'MultiProcessorCompilation' 'true'
Assert-ClCompileValue $appXml 'emule.vcxproj' $appReleaseCondition 'ControlFlowGuard' 'Guard'
Assert-LinkValue $appXml 'emule.vcxproj' $appReleaseCondition 'IncrementalLink' 'false'
Assert-LinkValue $appXml 'emule.vcxproj' $appReleaseCondition 'LinkControlFlowGuard' 'true'

$testsXml = Get-ProjectXml 'repos\eMule-build-tests\emule-tests.vcxproj'
Assert-NoProjectConfigurationPlatform $testsXml 'emule-tests.vcxproj' 'Win32'
Assert-NoProjectConfigurationName $testsXml 'emule-tests.vcxproj' '_SpecialBootstrapNodes'
Assert-PropertyGroupValue $testsXml 'emule-tests.vcxproj' $testsDebugCondition 'PlatformToolset' 'v143'
Assert-PropertyGroupValue $testsXml 'emule-tests.vcxproj' $testsReleaseCondition 'PlatformToolset' 'v143'
Assert-PropertyGroupValue $testsXml 'emule-tests.vcxproj' $testsDebugArm64Condition 'PlatformToolset' 'v143'
Assert-PropertyGroupValue $testsXml 'emule-tests.vcxproj' $testsReleaseArm64Condition 'PlatformToolset' 'v143'
Assert-ClCompileValue $testsXml 'emule-tests.vcxproj' $testsDebugBuildCondition 'LanguageStandard' 'stdcpp17'
Assert-ClCompileValue $testsXml 'emule-tests.vcxproj' $testsDebugBuildCondition 'Optimization' 'Disabled'
Assert-ClCompileValue $testsXml 'emule-tests.vcxproj' $testsDebugBuildCondition 'RuntimeLibrary' 'MultiThreadedDebug'
Assert-ClCompileValue $testsXml 'emule-tests.vcxproj' $testsDebugBuildCondition 'BufferSecurityCheck' 'true'
Assert-ClCompileValue $testsXml 'emule-tests.vcxproj' $testsDebugBuildCondition 'DebugInformationFormat' 'ProgramDatabase'
Assert-ClCompileValue $testsXml 'emule-tests.vcxproj' $testsDebugBuildCondition 'MultiProcessorCompilation' 'true'
Assert-LinkValue $testsXml 'emule-tests.vcxproj' $testsDebugBuildCondition 'IncrementalLink' 'true'
Assert-ClCompileValue $testsXml 'emule-tests.vcxproj' $testsReleaseBuildCondition 'LanguageStandard' 'stdcpp17'
Assert-ClCompileValue $testsXml 'emule-tests.vcxproj' $testsReleaseBuildCondition 'Optimization' 'MaxSpeed'
Assert-ClCompileValue $testsXml 'emule-tests.vcxproj' $testsReleaseBuildCondition 'RuntimeLibrary' 'MultiThreaded'
Assert-ClCompileValue $testsXml 'emule-tests.vcxproj' $testsReleaseBuildCondition 'BufferSecurityCheck' 'true'
Assert-ClCompileValue $testsXml 'emule-tests.vcxproj' $testsReleaseBuildCondition 'FunctionLevelLinking' 'true'
Assert-ClCompileValue $testsXml 'emule-tests.vcxproj' $testsReleaseBuildCondition 'IntrinsicFunctions' 'true'
Assert-ClCompileValue $testsXml 'emule-tests.vcxproj' $testsReleaseBuildCondition 'MultiProcessorCompilation' 'true'
Assert-LinkValue $testsXml 'emule-tests.vcxproj' $testsReleaseBuildCondition 'IncrementalLink' 'false'

$id3libXml = Get-ProjectXml 'repos\third_party\eMule-id3lib\libprj\id3lib.vcxproj'
foreach ($condition in @($id3libDebugX64Condition, $id3libDebugArm64Condition)) {
    Assert-ClCompileValue $id3libXml 'id3lib.vcxproj' $condition 'LanguageStandard' 'stdcpp17'
    Assert-ClCompileValue $id3libXml 'id3lib.vcxproj' $condition 'Optimization' 'Disabled'
    Assert-ClCompileValue $id3libXml 'id3lib.vcxproj' $condition 'BufferSecurityCheck' 'true'
    Assert-ClCompileValue $id3libXml 'id3lib.vcxproj' $condition 'DebugInformationFormat' 'ProgramDatabase'
    Assert-ClCompileValue $id3libXml 'id3lib.vcxproj' $condition 'MultiProcessorCompilation' 'true'
    Assert-ClCompileValue $id3libXml 'id3lib.vcxproj' $condition 'RuntimeLibrary' 'MultiThreadedDebug'
}
foreach ($condition in @($id3libReleaseX64Condition, $id3libReleaseArm64Condition)) {
    Assert-ClCompileValue $id3libXml 'id3lib.vcxproj' $condition 'LanguageStandard' 'stdcpp17'
    Assert-ClCompileValue $id3libXml 'id3lib.vcxproj' $condition 'BufferSecurityCheck' 'true'
    Assert-ClCompileValue $id3libXml 'id3lib.vcxproj' $condition 'MultiProcessorCompilation' 'true'
    Assert-ClCompileValue $id3libXml 'id3lib.vcxproj' $condition 'RuntimeLibrary' 'MultiThreaded'
    Assert-ClCompileValue $id3libXml 'id3lib.vcxproj' $condition 'FunctionLevelLinking' 'true'
    Assert-ClCompileValue $id3libXml 'id3lib.vcxproj' $condition 'IntrinsicFunctions' 'true'
    Assert-ClCompileValue $id3libXml 'id3lib.vcxproj' $condition 'WholeProgramOptimization' 'true'
}

$resizableXml = Get-ProjectXml 'repos\third_party\eMule-ResizableLib\ResizableLib\ResizableLib.vcxproj'
foreach ($condition in @($resizableDebugX64Condition, $resizableDebugArm64Condition)) {
    Assert-ClCompileValue $resizableXml 'ResizableLib.vcxproj' $condition 'LanguageStandard' 'stdcpp17'
    Assert-ClCompileValue $resizableXml 'ResizableLib.vcxproj' $condition 'Optimization' 'Disabled'
    Assert-ClCompileValue $resizableXml 'ResizableLib.vcxproj' $condition 'BufferSecurityCheck' 'true'
    Assert-ClCompileValue $resizableXml 'ResizableLib.vcxproj' $condition 'MultiProcessorCompilation' 'true'
    Assert-ClCompileValue $resizableXml 'ResizableLib.vcxproj' $condition 'RuntimeLibrary' 'MultiThreadedDebug'
}
foreach ($condition in @($resizableReleaseX64Condition, $resizableReleaseArm64Condition)) {
    Assert-ClCompileValue $resizableXml 'ResizableLib.vcxproj' $condition 'LanguageStandard' 'stdcpp17'
    Assert-ClCompileValue $resizableXml 'ResizableLib.vcxproj' $condition 'Optimization' 'MaxSpeed'
    Assert-ClCompileValue $resizableXml 'ResizableLib.vcxproj' $condition 'BufferSecurityCheck' 'true'
    Assert-ClCompileValue $resizableXml 'ResizableLib.vcxproj' $condition 'MultiProcessorCompilation' 'true'
    Assert-ClCompileValue $resizableXml 'ResizableLib.vcxproj' $condition 'RuntimeLibrary' 'MultiThreaded'
    Assert-ClCompileValue $resizableXml 'ResizableLib.vcxproj' $condition 'FunctionLevelLinking' 'true'
}

$miniupnpXml = Get-ProjectXml 'repos\third_party\eMule-miniupnp\miniupnpc\msvc\miniupnpc.vcxproj'
foreach ($condition in @($miniupnpDebugX64Condition, $miniupnpDebugArm64Condition)) {
    Assert-ClCompileValue $miniupnpXml 'miniupnpc.vcxproj' $condition 'Optimization' 'Disabled'
    Assert-ClCompileValue $miniupnpXml 'miniupnpc.vcxproj' $condition 'BufferSecurityCheck' 'true'
    Assert-ClCompileValue $miniupnpXml 'miniupnpc.vcxproj' $condition 'MultiProcessorCompilation' 'true'
    Assert-ClCompileValue $miniupnpXml 'miniupnpc.vcxproj' $condition 'RuntimeLibrary' 'MultiThreadedDebug'
}
foreach ($condition in @($miniupnpReleaseX64Condition, $miniupnpReleaseArm64Condition)) {
    Assert-ClCompileValue $miniupnpXml 'miniupnpc.vcxproj' $condition 'Optimization' 'MaxSpeed'
    Assert-ClCompileValue $miniupnpXml 'miniupnpc.vcxproj' $condition 'BufferSecurityCheck' 'true'
    Assert-ClCompileValue $miniupnpXml 'miniupnpc.vcxproj' $condition 'MultiProcessorCompilation' 'true'
    Assert-ClCompileValue $miniupnpXml 'miniupnpc.vcxproj' $condition 'RuntimeLibrary' 'MultiThreaded'
    Assert-ClCompileValue $miniupnpXml 'miniupnpc.vcxproj' $condition 'FunctionLevelLinking' 'true'
    Assert-ClCompileValue $miniupnpXml 'miniupnpc.vcxproj' $condition 'IntrinsicFunctions' 'true'
}

$cryptoppXml = Get-ProjectXml 'repos\third_party\eMule-cryptopp\cryptlib.vcxproj'
Assert-ClCompileValue $cryptoppXml 'cryptlib.vcxproj' $cryptoppDebugCondition 'Optimization' 'Disabled'
Assert-ClCompileValue $cryptoppXml 'cryptlib.vcxproj' $cryptoppDebugCondition 'BufferSecurityCheck' 'true'
Assert-ClCompileValue $cryptoppXml 'cryptlib.vcxproj' $cryptoppDebugCondition 'DebugInformationFormat' 'ProgramDatabase'
Assert-ClCompileValue $cryptoppXml 'cryptlib.vcxproj' $cryptoppDebugCondition 'MultiProcessorCompilation' 'true'
Assert-ClCompileValue $cryptoppXml 'cryptlib.vcxproj' $cryptoppDebugCondition 'RuntimeLibrary' 'MultiThreadedDebug'
Assert-ClCompileValue $cryptoppXml 'cryptlib.vcxproj' $cryptoppReleaseCondition 'Optimization' 'MaxSpeed'
Assert-ClCompileValue $cryptoppXml 'cryptlib.vcxproj' $cryptoppReleaseCondition 'BufferSecurityCheck' 'true'
Assert-ClCompileValue $cryptoppXml 'cryptlib.vcxproj' $cryptoppReleaseCondition 'MultiProcessorCompilation' 'true'
Assert-ClCompileValue $cryptoppXml 'cryptlib.vcxproj' $cryptoppReleaseCondition 'RuntimeLibrary' 'MultiThreaded'
Assert-ClCompileValue $cryptoppXml 'cryptlib.vcxproj' $cryptoppReleaseCondition 'FunctionLevelLinking' 'true'
Assert-ClCompileValue $cryptoppXml 'cryptlib.vcxproj' $cryptoppReleaseCondition 'IntrinsicFunctions' 'true'

Write-Host 'Active build policy audit passed.'
