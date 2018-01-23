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
        [string] $SifConfigPathNewSitecoreCerts,
        [string] $ConfigPath,
        [string] $SitecorePackagePath,
        [string] $LicenseFilePath,
        [string] $CertPathFolder,
        [string] $XConnectCertificateName
    )
    Process {


        #Enable-SIF -SifPath .\Resources\SitecoreInstallFramework -FundamentalsPath .\Resources\SitecoreFundamentals

        # Prepare selfsigned certificates for Sitecore
        if ($SifConfigPathNewSitecoreCerts -ne "") {
            if (Test-Path -Path $SifConfigPathNewSitecoreCerts) {
                New-SifSitecoreCertificates -ConfigPath $SifConfigPathNewSitecoreCerts -CertPathFolder $CertPathFolder
            }
            else {
                Write-Warning "'$SifConfigPathNewSitecoreCerts' does not exist, skipping creation of self signed certs for Sitecore."
            }
        }
        else {
            Write-Warning "Parameter 'SifConfigPathNewSitecoreCerts' not provided, skipping creation of self signed certs for Sitecore."
        }


        # Install Sitecore Databases
        #Invoke-SifSitecoreDatabases -ConfigPath $ConfigPath -PackagePath $SitecorePackagePath
        
        # Prepare Sitecore environment (without Sitecore WebRoot Deployment)
        Invoke-SIFSitecoreInstance -ConfigPath $ConfigPath -XConnectCertificateName $XConnectCertificateName

        # Deploy Sitecore WebRoot and patch (connectionstrings, solr, xConnect) to environment setup
        Invoke-SifSitecoreWebsite -ConfigPath $ConfigPath -PackagePath $SitecorePackagePath -LicenseFile $LicenseFilePath -XConnectCert $XConnectCertificateName


        
        <#
        
        $sitecoreParams = @{
            Path                = $ConfigPath
            SiteGlobalWebPath   = $SiteGlobalWebPath
            Sitename            = $Sitename
            WebFolderName       = $WebFolderName
            XConnectCert        = $XConnectCertificateName
            Tasks               = @("CreatePaths")
        }             
        Install-SitecoreConfiguration @sitecoreParams
        #>
    }
}
