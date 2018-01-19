<#
.SYNOPSIS
Installs IndexWorker and MarketingAutomationEngine services.

.DESCRIPTION
Installs IndexWorker and MarketingAutomationEngine services.

.EXAMPLE

.NOTES
Webiste has to be installed first because of reference to App_Data\jobs\continuous\(AutomationEngine|IndexWorker) content.

#>
function Invoke-SifXConnectServices {
    [CmdletBinding()]
    Param(
        [string] $Prefix,
        [string] $ConfigPath = "d:\asia\scratch\xconnect-xp0.json"   
    )
    Process {

        $xconnectParams = @{
            Path        = $ConfigPath
            LicenseFile = "d:\asia\scratch\license.xml"
            Sitename    = "$prefix.xconnect"
            Tasks       = @("StopServices", "RemoveServices", "CreateServicesLogPaths", "SetIndexWorkerServiceLicense", "SetMarketingAutomationServiceLicense", `
                    "SetIndexWorkerServicePermissions", "SetMarketingAutomationServicePermissions", "InstallServices", "StartServices")
        }
        Install-SitecoreConfiguration @xconnectParams
    }
}
