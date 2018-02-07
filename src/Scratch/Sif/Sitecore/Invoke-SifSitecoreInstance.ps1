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
function Invoke-SifSitecoreInstance {
    [CmdletBinding()]
    Param(
        [string] $ConfigPath
    )
    Process {
        $InstallationConfig = Get-ScScratchProjectConfig

        # Site parameters
        $SiteGlobalWebPath = $InstallationConfig.GlobalWebPath
        $Sitename = $InstallationConfig.WebsiteCodeName 
        $WebFolderName = $InstallationConfig.WebFolderName
        # Additional parameters 
        $HostsFileComment = $InstallationConfig.HostsFileComment
        $XConnectClientCertificateName = $InstallationConfig.XConnectClientCertificateName

        $sitecoreParams = @{
            Path                = $ConfigPath
            SiteGlobalWebPath   = $SiteGlobalWebPath
            Sitename            = $Sitename
            WebFolderName       = $WebFolderName
            HostsFileComment    = $HostsFileComment
            XConnectCert        = $XConnectClientCertificateName
            Skip                = @("InstallWDP", "SetLicense", "UpdateSolrSchema")
        }             
        Install-SitecoreConfiguration @sitecoreParams
    }
}

