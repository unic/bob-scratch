<#
.SYNOPSIS
Installs and configure IIS site..

.DESCRIPTION
Installs IIS site and sets permissions, bindings, certificates and configuration.

.EXAMPLE
Invoke-SifXConnectInstance -ConfigPath "xconnect-xp0.json" -Sitename "$prefix.xconnect" -XConnectCert "xp0.xconnect_client"

.NOTES
Requirements for configuration file comparing to default xconnect-XP0.json

- parameters not anymore mandatory: Package, LicenseFile, 
- [variable('Site.DataFolder')] added to CreatePaths task

#>
function Invoke-SifXConnectInstance {
    [CmdletBinding()]
    Param(
        [string] $ConfigPath,
        [string] $Sitename,
        [string] $XConnectCert      
    )
    Process {

        $xconnectParams = @{
            Path         = $ConfigPath
            Sitename     = $Sitename
            XConnectCert = $XConnectCert
            Tasks        = @("CreatePaths", "CreateAppPool", "SetAppPoolCertStorePermissions", "CreateWebsite", "StopWebsite", "StopAppPool", `
                    "RemoveDefaultBinding", "CreateBindingsWithThumprint", "SetClientCertificatePermissions", "SupportListManagerLargeUpload", `
                    "CreateHostHeader", "SetPermissions", "CreateBindingsWithDevelopmentThumprint", "SetServicesCertStorePermissions", `
                    "StartAppPool", "StartWebsite")
        }
        Install-SitecoreConfiguration @xconnectParams
    }
}
