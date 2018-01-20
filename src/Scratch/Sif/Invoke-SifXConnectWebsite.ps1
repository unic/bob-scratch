<#
.SYNOPSIS
Installs xConnect website from WebDeploy package.

.EXAMPLE
Invoke-SifXConnectWebsite -ConfigPath "xconnect-xp0.json" -PackagePath "Sitecore9_xp0xconnect.scwdp.zip" `
    -SqlDbPrefix $prefix -SqlServer "localhost" -SqlUserPassword "H6dfVh2QGU" -LicenseFile "license.xml" `
    -XConnectCert "xp0.xconnect_client" -Sitename "$prefix.xconnect"

#>
function Invoke-SifXConnectWebsite {
    [CmdletBinding()]
    Param(
        [string] $ConfigPath,
        [string] $PackagePath,
        [string] $LicenseFile,
        [string] $SqlDbPrefix,
        [string] $SolrCorePrefix,
        [string] $SqlUserPassword,
        [string] $SqlServer,
        [string] $Sitename,
        [string] $XConnectCert
    )
    Process {

        $xconnectParams = @{
            Path                           = $ConfigPath
            Package                        = $PackagePath
            LicenseFile                    = $LicenseFile
            Sitename                       = $Sitename
            XConnectCert                   = $XConnectCert
            SqlDbPrefix                    = $SqlDbPrefix
            SqlServer                      = $SqlServer
            SolrCorePrefix                 = $SolrCorePrefix
            SqlCollectionPassword          = $SqlUserPassword
            SqlProcessingPoolsPassword     = $SqlUserPassword
            SqlReferenceDataPassword       = $SqlUserPassword
            SqlMarketingAutomationPassword = $SqlUserPassword
            WdpSkip                        = @{ "objectName" = "dbDacFx" }, @{ "objectName" = "dbFullSql" }
            Tasks                          = @("CreatePaths", "StopAppPool", "InstallWDP", "SetLicense", "StartAppPool")
        }
        Install-SitecoreConfiguration @xconnectParams
    }
}
