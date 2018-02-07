<#
.SYNOPSIS
Installs a Sitecore instance

.DESCRIPTION
The Sitecore instance installation includes databases, instance and solr schema.

.EXAMPLE
tbd

.NOTES
tbd

#>
function Install-SitecoreSetup {
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
