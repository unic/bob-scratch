<#
.SYNOPSIS
Updates solr schema.

.DESCRIPTION
Updates solr schema by calling /sitecore/admin/PopulateManagedSchema.aspx?indexes=all

.EXAMPLE
Install-SolrSchema -ConfigPath "D:\asia\scratch\sitecore-XP0.json" -Sitename "xp0.sc"

.NOTES
Requirements for configuration file comparing to default sitecore-XP0.json

- parameters not anymore mandatory: Package, LicenseFile, SolrCorePrefix, XConnectCert

- to handle invalid XConnectCert:
    1. added to Modules:
	Modules : [
		".\\SifExtension\\GetCertificateThumbprintSilently.psm1"
    ]
    2. variable Security.XConnect.CertificateThumbprint change to "[TryGetCertificateThumbprint(parameter('XConnectCert'), variable('Security.CertificateStore'))]"
#>
function Install-SolrSchema {
    [CmdletBinding()]
    Param(
        [string] $ConfigPath,
        [string] $Sitename,
        [string] $SitecoreAdminPassword = "b"
    )
    Process {

        $sitecoreParams = @{
            Path = $ConfigPath
            Sitename = $Sitename
            SitecoreAdminPassword = $SitecoreAdminPassword
            Tasks = @("UpdateSolrSchema")
        }             
        Install-SitecoreConfiguration @sitecoreParams
    }
}

