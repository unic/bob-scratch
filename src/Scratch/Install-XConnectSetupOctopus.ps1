<#
.SYNOPSIS
Installs xConnect

.DESCRIPTION
Installs an xConnect instance including databases and services.

.EXAMPLE
tbd

.NOTES
tbd

#>
function Install-XConnectSetup {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [ValidateScript( { Test-Path $_ })]
        [string] $ModuleSifPath,
        [Parameter(Mandatory = $true)]
        [ValidateScript( { Test-Path $_ })]
        [string] $ModuleFundamentalsPath,
        [Parameter(Mandatory = $true)]
        [ValidateScript( { Test-Path $_ })]
        [string] $SifConfigPathXConnectXp0,
        [Parameter(Mandatory = $true)]
        [ValidateScript( { Test-Path $_ })]
        [string] $XConnectPackagePath,
        [string] $TargetWebDir,
        [string] $SiteName
    )
    Process {

        # Load SIF Modules
        Enable-SIF -SifPath $ModuleSifPath -FundamentalsPath $ModuleFundamentalsPath

        # Deploy XConnect WebRoot and patch (connectionstrings, solr) to environment setup
        Invoke-SifXConnectWebsiteOctopus `
            -ConfigPath $SifConfigPathXConnectXp0 `
            -PackagePath $XConnectPackagePath `
            -TargetWebDir $TargetWebDir `
            -SiteName $SiteName
    }
}
