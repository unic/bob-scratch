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
        [string] $LicenseFile,
        [string] $SiteName
    )
    Process {

        $xconnectParams = @{
            Path        = $ConfigPath
            LicenseFile = $LicenseFile
            Sitename    = $SiteName
            Tasks       = @("StopServices", "RemoveServices", "CreateServicesLogPaths", "SetIndexWorkerServiceLicense", "SetMarketingAutomationServiceLicense", `
                    "SetIndexWorkerServicePermissions", "SetMarketingAutomationServicePermissions", "InstallServices", "StartServices")
        }
        Install-SitecoreConfiguration @xconnectParams
    }
}
