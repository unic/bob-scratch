<#
.SYNOPSIS
Installs xConnect website from WebDeploy package.

.EXAMPLE
Invoke-SifXConnectWebsite -ConfigPath "xconnect-xp0.json" -PackagePath "Sitecore9_xp0xconnect.scwdp.zip" `
    -SqlDbPrefix $prefix -SqlServer "localhost" -SqlUserPassword "H6dfVh2QGU" -LicenseFile "license.xml" `
    -XConnectCert "xp0.xconnect_client" -Sitename "$prefix.xconnect"

#>
function Invoke-SifXConnectWebsiteOctopus {
    [CmdletBinding()]
    Param(
        [string] $ConfigPath,
        [string] $PackagePath,
        [string] $TargetWebDir,
        [string] $SiteName
    )
    Process {

        Write-Host $ConfigPath
        Write-Host $PackagePath
        Write-Host $TargetWebDir
        Write-Host $Sitename


        $xconnectParams = @{
            Path                           = $ConfigPath
            Package                        = $PackagePath
            SiteGlobalWebPath              = $TargetWebDir
            Sitename                       = $Sitename
            WebFolderName                  = ""
            WdpSkip                        = @{ "objectName" = "dbDacFx" }, @{ "objectName" = "dbFullSql" }
            Tasks                          = @("CreatePaths", "InstallWDP")
            # Important: XConnect Services are stopped because of File-locks, but not started because of missing licenses after redeployment of webroot dir.
            # Use 'Invoke-SifXConnectServices' to get them prepared and started again
        }

        
        $xconnectParams | Format-Table

        Install-SitecoreConfiguration @xconnectParams
    }
}
