<#
.SYNOPSIS
Installs a Sitecore instance.

.DESCRIPTION
Installs a Sitecore instance with an Octopus Deploy specific configuration.

.EXAMPLE
tbd

.NOTES
tbd

#>
function Install-SitecoreSetupOctopus {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path $_ })]
        [string] $ModuleSifPath,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path $_ })]
        [string] $ModuleFundamentalsPath,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path $_ })]
        [string] $SifConfigPathSitecoreXp0,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path $_ })]
        [string] $SitecorePackagePath,
        [string] $TargetWebDir,
        [string] $SiteName
    )
    Process {

        # Load SIF Modules
        Enable-SIF -SifPath $ModuleSifPath -FundamentalsPath $ModuleFundamentalsPath

        # Deploy Sitecore WebRoot and patch (connectionstrings, solr, xConnect) to environment setup
        Invoke-SifSitecoreWebsiteOctopus -ConfigPath $SifConfigPathSitecoreXp0 -PackagePath $SitecorePackagePath -TargetWebDir $TargetWebDir -SiteName $SiteName

    }
}
