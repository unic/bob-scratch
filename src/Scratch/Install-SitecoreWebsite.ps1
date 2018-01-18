<#
.SYNOPSIS
Installs Sitecore from WebDeploy package.

.DESCRIPTION
Installs Sitecore to existing website, from WebDeploy package, using SIF. Copy license file. Updates ConnectionStrings.config

.EXAMPLE
Install-SitecoreWebsite -ConfigPath "D:\asia\scratch\sitecore-XP0.json" -PackagePath "D:\asia\scratch\Sitecore9.scwdp.zip" `
    -SqlDbPrefix "xp0" -SolrCorePrefix "xp0" -SqlUserPassword "H6dfVh2QGU" -SqlServer "localhost" `
    -LicenseFile "D:\asia\scratch\license.xml" -Sitename "xp0.sc" -XConnectCertificateName "xp0.xconnect_client"

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
function Install-SitecoreWebsite {
    [CmdletBinding()]
    Param(
        [string] $ConfigPath,
        [string] $PackagePath,
        [string] $SqlDbPrefix,
        [string] $SolrCorePrefix,
        [string] $SqlUserPassword,
        [string] $SqlServer,
        [string] $LicenseFile,
        [string] $Sitename,
        [string] $XConnectCertificateName
    )
    Process {

        $sitecoreParams = @{
            Path = $ConfigPath
            Package = $PackagePath
            Sitename = $Sitename
            SqlDbPrefix = $SqlDbPrefix
            SqlServer = $SqlServer
            SqlCorePassword = $SqlUserPassword
            SqlMasterPassword = $SqlUserPassword
            SqlWebPassword = $SqlUserPassword
            SqlReportingPassword = $SqlUserPassword
            SqlProcessingPoolsPassword = $SqlUserPassword
            SqlProcessingTasksPassword = $SqlUserPassword
            SqlReferenceDataPassword = $SqlUserPassword
            SqlMarketingAutomationPassword = $SqlUserPassword
            SqlFormsPassword = $SqlUserPassword
            SolrCorePrefix = $SolrCorePrefix
            XConnectCert = $XConnectCertificateName
            LicenseFile = $LicenseFile
            WdpSkip = @{ "objectName" = "dbDacFx" }, @{ "objectName" = "dbFullSql" }
            Tasks = @("CreatePaths", "StopAppPool", "InstallWDP", "SetLicense", "StartAppPool")
        }             
        Install-SitecoreConfiguration @sitecoreParams
    }
}

