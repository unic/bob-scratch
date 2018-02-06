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
function Install-Sitecore12 {
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
        [string] $SifConfigPathSitecoreXp0,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path $_ })]
        [string] $SitecorePackagePath,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path $_ })]
        [string] $LicenseFilePath,
        [string] $CertPathFolder = ".\Output\Certificates"
    )
    Process {

        # Load SIF Modules
        Enable-SIF -SifPath $ModuleSifPath -FundamentalsPath $ModuleFundamentalsPath

        # Temporary change location so SIF can find the extensions
        Push-Location $(Split-Path(Split-Path -parent $script:MyInvocation.MyCommand.Path))

        try{
            # Prepare selfsigned certificates for Sitecore
            if ($SifConfigPathCreateCerts -ne "") {
                if (Test-Path -Path $SifConfigPathCreateCerts) {
                    New-SifSitecoreCertificates -ConfigPath $SifConfigPathCreateCerts -CertPathFolder $CertPathFolder
                }
                else {
                    Write-Warning "'$SifConfigPathCreateCerts' does not exist, skipping creation of self signed certs for Sitecore."
                }
            }
            else {
                Write-Warning "Parameter 'SifConfigPathCreateCerts' not provided, skipping creation of self signed certs for Sitecore."
            }

            # Install Sitecore Databases
            Invoke-SifSitecoreDatabases -ConfigPath $SifConfigPathSitecoreXp0 -PackagePath $SitecorePackagePath
            
            # Prepare Sitecore environment (without Sitecore WebRoot Deployment)
            Invoke-SIFSitecoreInstance -ConfigPath $SifConfigPathSitecoreXp0

            # Deploy Sitecore WebRoot and patch (connectionstrings, solr, xConnect) to environment setup
            Invoke-SifSitecoreWebsite -ConfigPath $SifConfigPathSitecoreXp0 -PackagePath $SitecorePackagePath -LicenseFile $LicenseFilePath

            # Update Sitecore Solr Schemas
            Invoke-SifSitecoreSolrSchema -ConfigPath $SifConfigPathSitecoreXp0
        }
        finally{
            # Revert location change
            Pop-Location
        }
    }
}
