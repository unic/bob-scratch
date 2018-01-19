
function Invoke-SifXConnectWebsite {
    [CmdletBinding()]
    Param(
        [string] $Prefix,
        [string] $ConfigPath = "d:\asia\scratch\xconnect-xp0.json",
        [string] $PackagePath = "d:\asia\scratch\Sitecore9_xp0xconnect.scwdp.zip"        
    )
    Process {

        $xconnectParams = @{
            Path                           = $ConfigPath
            Package                        = $PackagePath
            LicenseFile                    = "d:\asia\scratch\license.xml"
            Sitename                       = "$prefix.xconnect"
            XConnectCert                   = "xp0.xconnect_client"
            SqlDbPrefix                    = $prefix
            SqlServer                      = "localhost"
            SqlAdminUser                   = "sa"
            SqlAdminPassword               = "sa"
            SolrCorePrefix                 = $prefix
            SolrURL                        = "https://localhost:8989/solr"
            SqlCollectionPassword          = "H6dfVh2QGU"
            SqlProcessingPoolsPassword     = "H6dfVh2QGU"
            SqlReferenceDataPassword       = "H6dfVh2QGU"
            SqlMarketingAutomationPassword = "H6dfVh2QGU"
            WdpSkip                        = @{ "objectName" = "dbDacFx" }, @{ "objectName" = "dbFullSql" }
            Tasks                          = @("CreatePaths", "StopAppPool", "InstallWDP", "SetLicense", "StartAppPool")
        }
        Install-SitecoreConfiguration @xconnectParams
    }
}
