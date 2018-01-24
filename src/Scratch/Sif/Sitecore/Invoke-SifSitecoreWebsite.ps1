<#
.SYNOPSIS
Installs Sitecore from WebDeploy package.

.DESCRIPTION
Installs Sitecore to existing website, from WebDeploy package, using SIF. Copy license file. Updates ConnectionStrings.config

.EXAMPLE
Install-SitecoreWebsite -ConfigPath "sitecore-XP0.json" -PackagePath "Sitecore9.scwdp.zip" `
    -SqlDbPrefix "xp0" -SolrCorePrefix "xp0" -SqlUserPassword "H6dfVh2QGU" -SqlServer "localhost" `
    -LicenseFile "license.xml" -Sitename "xp0.sc" -XConnectCertificateName "xp0.xconnect_client"

.NOTES
Requirements for configuration file comparing to default sitecore-XP0.json
- added to Parameters:
		"WdpSkip": {
            "Type": "Object[]",
            "DefaultValue": "@()",
            "Description": "Value of skip argument for InstallWDP task."
        },

- added to InstallWDP.Params.Arguments:
                    "Skip": "[parameter('WdpSkip')]",

- parameters not anymore mandatory: SolrCorePrefix

#>
function Invoke-SifSitecoreWebsite {
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
        $Sitename = $InstallationConfig.WebsiteCodeName 
        $WebFolderName = $InstallationConfig.WebFolderName
        # Database parameters (used to replace values in connectionString.config)
        $SqlDbPrefix = $InstallationConfig.DatabaseDbPrefix
        $SqlDbServer = $InstallationConfig.DatabaseServer
        $SqlDbSitecoreUserPwd = $InstallationConfig.DatabaseSitecoreDbUserPwd
        # Solr parameters (used to replace values in solr patching files)
        $SolrCorePrefix = $InstallationConfig.SolrCorePrefix
        $SolrUrl = $InstallationConfig.SolrUrl
        # XConnect parameters (used to replace values in connectionString.config)
        $xConnectRootUrl = Get-XConnectWebsiteUrl
        $XConnectClientCertificateName = $InstallationConfig.XConnectClientCertificateName


        $sitecoreParams = @{
            Path                           = $ConfigPath
            Package                        = $PackagePath
            SiteGlobalWebPath              = $SiteGlobalWebPath
            Sitename                       = $Sitename
            WebFolderName                  = $WebFolderName
            SqlDbPrefix                    = $SqlDbPrefix
            SqlServer                      = $SqlDbServer
            SqlCorePassword                = $SqlDbSitecoreUserPwd
            SqlMasterPassword              = $SqlDbSitecoreUserPwd
            SqlWebPassword                 = $SqlDbSitecoreUserPwd
            SqlReportingPassword           = $SqlDbSitecoreUserPwd
            SqlProcessingPoolsPassword     = $SqlDbSitecoreUserPwd
            SqlProcessingTasksPassword     = $SqlDbSitecoreUserPwd
            SqlReferenceDataPassword       = $SqlDbSitecoreUserPwd
            SqlMarketingAutomationPassword = $SqlDbSitecoreUserPwd
            SqlFormsPassword               = $SqlDbSitecoreUserPwd
            SqlExmMasterPassword           = $SqlDbSitecoreUserPwd
            SolrCorePrefix                 = $SolrCorePrefix
            SolrUrl                        = $SolrUrl
            XConnectCollectionService      = $xConnectRootUrl
            XConnectCert                   = $XConnectClientCertificateName
            LicenseFile                    = $LicenseFile
            WdpSkip                        = @{ "objectName" = "dbDacFx" }, @{ "objectName" = "dbFullSql" }
            Tasks                          = @("CreatePaths", "StopAppPool", "InstallWDP", "SetLicense", "StartAppPool")
        }             
        Install-SitecoreConfiguration @sitecoreParams
    }
}

