$ErrorActionPreference = "Stop"

$PSScriptRoot = Split-Path  $script:MyInvocation.MyCommand.Path
Write-Host "Root: $PSScriptRoot"

function ResolvePath() {
    param($PackageId, $RelativePath)
    $paths = @("$PSScriptRoot\..\..\packages", "$PSScriptRoot\..\tools", "$PSScriptRoot\..\..\..\packages")
    foreach ($packPath in $paths) {
        $path = Join-Path $packPath "$PackageId\$RelativePath"
        Write-Host $path
        if ((Test-Path $packPath) -and (Test-Path $path)) {
            Resolve-Path $path
            return
        }
    }
    Write-Error "No path found for $RelativePath in package $PackageId"
}

Get-ChildItem -Path $PSScriptRoot\*.ps1 -Recurse -Exclude *.tests.ps1 | Foreach-Object { . $_.FullName }
Export-ModuleMember -Function * -Alias *

Import-Module (ResolvePath "Unic.Bob.Wendy" "tools\Wendy") -Force
Export-ModuleMember -Function Get-ScProjectConfig

$VerbosePreference = "Continue"