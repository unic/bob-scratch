<#
.SYNOPSIS
Installs IndexWorker and MarketingAutomationEngine services.

.DESCRIPTION
Installs IndexWorker and MarketingAutomationEngine services.

.EXAMPLE
Invoke-SifXConnectServices -ConfigPath "xconnect-xp0.json" -Sitename "$prefix.xconnect" -LicenseFile "license.xml"

.NOTES
Webiste has to be installed first because of reference to App_Data\jobs\continuous\(AutomationEngine|IndexWorker) content.

#>
function Invoke-SifXConnectServices {
    [CmdletBinding()]
    Param(
        [string] $ConfigPath,
        [string] $LicenseFile
    )
    Process {

        $InstallationConfig = Get-ScScratchProjectConfig

        # Site parameters
        $SiteGlobalWebPath = $InstallationConfig.GlobalWebPath
        $Sitename = $InstallationConfig.XConnectWebsiteCodename 
        $WebFolderName = $InstallationConfig.XConnectWebFoldername

        $xconnectParams = @{
            Path        = $ConfigPath
            SiteGlobalWebPath   = $SiteGlobalWebPath
            Sitename            = $Sitename
            WebFolderName       = $WebFolderName
            LicenseFile = $LicenseFile
            Tasks       = @("StopServices", "RemoveServices", "CreateServicesLogPaths", "SetIndexWorkerServiceLicense", "SetMarketingAutomationServiceLicense", `
                    "SetIndexWorkerServicePermissions", "SetMarketingAutomationServicePermissions", "InstallServices", "StartServices")
        }
        Install-SitecoreConfiguration @xconnectParams
    }
}
