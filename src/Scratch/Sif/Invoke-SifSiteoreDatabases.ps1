<#
.SYNOPSIS
Installs Sitecore databases from WebDeploy package

.DESCRIPTION
Installs all databases from WebDeploy package using SIF.

.EXAMPLE
Install-SitecoreDatabases -ConfigPath "sitecore-XP0.json" -PackagePath "Sitecore9.scwdp.zip" `
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
function Invoke-SifSitecoreDatabases {
    [CmdletBinding()]
    Param(
        [string] $ConfigPath,
        [string] $PackagePath
    )
    Process {
        $InstallationConfig = Get-ScProjectConfig -ConfigFileName @("Installation.config", "Installation.config.user")

        # Database parameters (used to setup databases)
        $SqlDbPrefix = $InstallationConfig.DatabaseDbPrefix
        $SqlDbServer = $InstallationConfig.DatabaseServer
        $SqlDbSitecoreUserPwd = $InstallationConfig.DatabaseSitecoreDbUserPwd
        
        $SqlAdminUser = $config.DatabaseAdminUser
        $SqlAdminPwd = $config.DatabaseAdminPwd

        $sitecoreParams = @{
            Path                           = $ConfigPath
            Package                        = $PackagePath
            SqlDbPrefix                    = $SqlDbPrefix
            SqlServer                      = $SqlServer
            SqlAdminUser                   = $SqlAdminUser
            SqlAdminPassword               = $SqlAdminPassword
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
            WdpSkip                        = @{ "objectName" = "iisApp" }
            Tasks                          = @("InstallWDP")
        }             
        Install-SitecoreConfiguration @sitecoreParams
    }
}

