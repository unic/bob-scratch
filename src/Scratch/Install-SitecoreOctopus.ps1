<#
.SYNOPSIS
Installs IIS site and sets permissions.

.DESCRIPTION
Installs IIS site and sets permissions.

.EXAMPLE
Install-SitecoreInstance -ConfigPath "sitecore-XP0.json" -Sitename "xp0.sc" -XConnectCertificateName "xp0.xconnect_client"

.NOTES
Requirements for configuration file comparing to default sitecore-XP0.json

- parameters not anymore mandatory: Package, LicenseFile, SolrCorePrefix, SqlDbPrefix

#>
function Install-Sitecore12Octopus {
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
