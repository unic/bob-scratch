<#
.SYNOPSIS
Installs IIS site and sets permissions.

.DESCRIPTION
Installs IIS site and sets permissions.

.EXAMPLE
Install-SitecoreInstance -ConfigPath "D:\asia\scratch\sitecore-XP0.json" -Sitename "xp0.sc" -XConnectCertificateName "xp0.xconnect_client"

.NOTES
Requirements for configuration file comparing to default sitecore-XP0.json
- parameters not anymore mandatory: Package, LicenseFile, SolrCorePrefix
#>
function Install-SitecoreInstance {
    [CmdletBinding()]
    Param(
        [string] $ConfigPath,
        [string] $Sitename,
        [string] $XConnectCertificateName
    )
    Process {

        $sitecoreParams = @{
            Path = $ConfigPath
            Sitename = $Sitename
            XConnectCert = $XConnectCertificateName
            Skip = @("InstallWDP", "SetLicense", "UpdateSolrSchema")
        }             
        Install-SitecoreConfiguration @sitecoreParams
    }
}

