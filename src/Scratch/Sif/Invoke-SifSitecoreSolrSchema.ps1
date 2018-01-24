<#
.SYNOPSIS
Updates solr schema.

.DESCRIPTION
Updates solr schema by calling /sitecore/admin/PopulateManagedSchema.aspx?indexes=all
https://doc.sitecore.net/sitecore_experience_platform/setting_up_and_maintaining/search_and_indexing/solr_managed_schemas

.EXAMPLE
Install-SolrSchema -ConfigPath "sitecore-XP0.json" -Sitename "xp0.sc"

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
function Invoke-SifSitecoreSolrSchema {
    [CmdletBinding()]
    Param(
        [string] $ConfigPath,
        [string] $SitecoreAdminPassword = "b"
    )
    Process {

        Import-Module .\SifExtension\ScratchSifExposedExtension.psm1 -force
        $bindings = Invoke-GetBobIISBindingsConfigFunction

        if ($bindings.Count -lt 1) {
            Write-Warning -Message "No Binding found, skipping Solr schema updating for Sitecore."
            return
        }

        $sitecoreRootUrl = "$($bindings[0].Protocol)://$($bindings[0].HostHeader)"

        $sitecoreParams = @{
            Path                  = $ConfigPath
            SiteUrl               = $sitecoreRootUrl
            SitecoreAdminPassword = $SitecoreAdminPassword
            Tasks                 = @("UpdateSolrSchema")
        }             
        Install-SitecoreConfiguration @sitecoreParams
    }
}

