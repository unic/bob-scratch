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
function Install-XConnect12 {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path $_ })]
        [string] $ModuleSifPath,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path $_ })]
        [string] $ModuleFundamentalsPath,
        [ValidateScript({ Test-Path $_ })]
        [string] $SifConfigPathCreateCerts,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path $_ })]
        [string] $SifConfigPathXConnectXp0,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path $_ })]
        [string] $XConnectPackagePath,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path $_ })]
        [string] $LicenseFilePath,
        [string] $CertPathFolder = ".\Output\Certificates"
    )
    Process {

        # Load SIF Modules
        Enable-SIF -SifPath $ModuleSifPath -FundamentalsPath $ModuleFundamentalsPath

        # Prepare selfsigned certificates for Sitecore
        if ($SifConfigPathCreateCerts -ne "") {
            if (Test-Path -Path $SifConfigPathCreateCerts) {
                New-SifXConnectCertificates -ConfigPath $SifConfigPathCreateCerts -CertPathFolder $CertPathFolder
            }
            else {
                Write-Warning "'$SifConfigPathCreateCerts' does not exist, skipping creation of self signed certs for XConnect."
            }
        }
        else {
            Write-Warning "Parameter 'SifConfigPathCreateCerts' not provided, skipping creation of self signed certs for XConnect."
        }

        # Temporary change location so SIF can find the extensions
        Push-Location $(Split-Path(Split-Path -parent $script:MyInvocation.MyCommand.Path))

        # Install XConnect Databases
        Invoke-SifXConnectDatabases -ConfigPath $SifConfigPathXConnectXp0 -PackagePath $XConnectPackagePath

        # Prepare XConnect environment (without Sitecore WebRoot Deployment)
        Invoke-SIFXConnectInstance -ConfigPath $SifConfigPathXConnectXp0 -CertPathFolder $CertPathFolder

        # Deploy XConnect WebRoot and patch (connectionstrings, solr) to environment setup
        Invoke-SifXConnectWebsite -ConfigPath $SifConfigPathXConnectXp0 -PackagePath $XConnectPackagePath -LicenseFile $LicenseFilePath

        # Deploy XConnect DB Shards
        Invoke-SifXConnectShards -ConfigPath $SifConfigPathXConnectXp0

        # Deploy XConnect Services
        Invoke-SifXConnectServices -ConfigPath $SifConfigPathXConnectXp0 -LicenseFile $LicenseFilePath

        # Revert location change
        Pop-Location
    }
}
