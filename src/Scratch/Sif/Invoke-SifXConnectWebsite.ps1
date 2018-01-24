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
        [string] $LicenseFile
    )
    Process {
        $InstallationConfig = Get-ScProjectConfig -ConfigFileName @("Installation.config", "Installation.config.user")

        # Site parameters
        $SiteGlobalWebPath = $InstallationConfig.GlobalWebPath
        $Sitename = $InstallationConfig.XConnectWebsiteCodename 
        $WebFolderName = $InstallationConfig.XConnectWebFoldername
        # Database parameters (used to replace values in connectionString.config)
        $SqlDbPrefix = $InstallationConfig.DatabaseDbPrefix
        $SqlDbServer = $InstallationConfig.DatabaseServer
        $SqlDbSitecoreUserPwd = $InstallationConfig.DatabaseSitecoreDbUserPwd
        # Solr parameters (used to replace values in solr patching files)
        $SolrCorePrefix = $InstallationConfig.SolrCorePrefix
        $SolrUrl = $InstallationConfig.SolrUrl
        # XConnect parameters (used to replace values in connectionString.config)
        $XConnectClientCertificateName = $InstallationConfig.XConnectClientCertificateName
        $xConnectRootUrl = Get-XConnectWebsiteUrl
        
        $xconnectParams = @{
            Path                           = $ConfigPath
            Package                        = $PackagePath
            SiteGlobalWebPath              = $SiteGlobalWebPath
            Sitename                       = $Sitename
            WebFolderName                  = $WebFolderName
            SiteUrl                        = $xConnectRootUrl
            SqlDbPrefix                    = $SqlDbPrefix
            SqlServer                      = $SqlDbServer
            SqlCollectionPassword          = $SqlDbSitecoreUserPwd
            SqlProcessingPoolsPassword     = $SqlDbSitecoreUserPwd
            SqlReferenceDataPassword       = $SqlDbSitecoreUserPwd
            SqlMarketingAutomationPassword = $SqlDbSitecoreUserPwd
            SqlMessagingPassword           = $SqlDbSitecoreUserPwd
            SolrCorePrefix                 = $SolrCorePrefix
            SolrUrl                        = $SolrUrl
            LicenseFile                    = $LicenseFile
            XConnectCert                   = $XConnectClientCertificateName
            WdpSkip                        = @{ "objectName" = "dbDacFx" }, @{ "objectName" = "dbFullSql" }
            Tasks                          = @("CreatePaths", "StopAppPool", "InstallWDP", "SetLicense", "StartAppPool")
        }
        Install-SitecoreConfiguration @xconnectParams
    }
}
