<#
.SYNOPSIS
Installs Sitecore databases from WebDeploy package

.DESCRIPTION
Installs all databases from WebDeploy package using SIF.

.EXAMPLE
Install-SitecoreDatabases -ConfigPath "D:\asia\scratch\sitecore-XP0.json" -PackagePath "D:\asia\scratch\Sitecore9.scwdp.zip" `
    -SqlDbPrefix "xp0" -SqlUserPassword "H6dfVh2QGU" -SqlServer "localhost" -SqlAdminUser "sa" -SqlAdminPassword "sa"

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

- parameters not anymore mandatory: LicenseFile, SolrCorePrefix, XConnectCert

- to handle invalid XConnectCert:
    1. added to Modules:
	Modules : [
		".\\SifExtension\\GetCertificateThumbprintSilently.psm1"
    ]
    2. variable Security.XConnect.CertificateThumbprint change to "[TryGetCertificateThumbprint(parameter('XConnectCert'), variable('Security.CertificateStore'))]"
#>
function Install-SitecoreDatabases {
    [CmdletBinding()]
    Param(
        [string] $ConfigPath,
        [string] $PackagePath,
        [string] $SqlDbPrefix,
        [string] $SqlUserPassword,
        [string] $SqlServer,
        [string] $SqlAdminUser,
        [string] $SqlAdminPassword
    )
    Process {

        $sitecoreParams = @{
            Path = $ConfigPath
            Package = $PackagePath
            SqlDbPrefix = $SqlDbPrefix
            SqlServer = $SqlServer
            SqlAdminUser = $SqlAdminUser
            SqlAdminPassword = $SqlAdminPassword
            SqlCorePassword = $SqlUserPassword
            SqlMasterPassword = $SqlUserPassword
            SqlWebPassword = $SqlUserPassword
            SqlReportingPassword = $SqlUserPassword
            SqlProcessingPoolsPassword = $SqlUserPassword
            SqlProcessingTasksPassword = $SqlUserPassword
            SqlReferenceDataPassword = $SqlUserPassword
            SqlMarketingAutomationPassword = $SqlUserPassword
            SqlFormsPassword = $SqlUserPassword
            WdpSkip = @{ "objectName" = "iisApp" }
            Tasks = @("InstallWDP")
        }             
        Install-SitecoreConfiguration @sitecoreParams
    }
}

