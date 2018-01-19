<#
.SYNOPSIS
Installs and configure IIS site..

.DESCRIPTION
Installs IIS site and sets permissions, bindings, certificates and configuration.

.EXAMPLE

.NOTES
Requirements for configuration file comparing to default xconnect-XP0.json

- parameters not anymore mandatory: Package, LicenseFile, 
- [variable('Site.DataFolder')] added to CreatePaths task

#>
function Invoke-SifXConnectInstance {
    [CmdletBinding()]
    Param(
        [string] $Prefix,
        [string] $ConfigPath = "d:\asia\scratch\xconnect-xp0.json",
        [string] $PackagePath = "d:\asia\scratch\Sitecore9_xp0xconnect.scwdp.zip"        
    )
    Process {

        $xconnectParams = @{
            Path         = $ConfigPath
            Sitename     = "$prefix.xconnect"
            XConnectCert = "xp0.xconnect_client"
            Tasks        = @("CreatePaths", "CreateAppPool", "SetAppPoolCertStorePermissions", "CreateWebsite", "StopWebsite", "StopAppPool", `
                    "RemoveDefaultBinding", "CreateBindingsWithThumprint", "SetClientCertificatePermissions", "SupportListManagerLargeUpload", `
                    "CreateHostHeader", "SetPermissions", "CreateBindingsWithDevelopmentThumprint", "SetServicesCertStorePermissions", `
                    "StartAppPool", "StartWebsite")
        }
        Install-SitecoreConfiguration @xconnectParams
    }
}
