<#
.SYNOPSIS
Installs xConnect databases from WebDeploy package

.DESCRIPTION
Installs all databases from WebDeploy package using SIF.

.EXAMPLE
Invoke-SifXConnectDatabases -ConfigPath "xconnect-xp0.json" -PackagePath "Sitecore9_xp0xconnect.scwdp.zip" `
    -SqlDbPrefix $prefix -SqlServer "localhost" -SqlAdminUser "sa" -SqlAdminPassword "sa" -SqlUserPassword "H6dfVh2QGU"

.NOTES
Before running it for a second time on same databases, manual task might be required - removing sql users: poolsuser, marketingautomationuser, referencedatauser.
Issue explained here: https://chebalt.wordpress.com/2017/11/22/sitecore-9-installation-tips/

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

function Invoke-SifXConnectDatabases {
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

        $xconnectParams = @{
            Path                           = $ConfigPath
            Package                        = $PackagePath
            SqlDbPrefix                    = $SqlDbPrefix
            SqlServer                      = $SqlServer
            SqlAdminUser                   = $SqlAdminUser
            SqlAdminPassword               = $SqlAdminPassword
            SqlCollectionPassword          = $SqlUserPassword
            SqlProcessingPoolsPassword     = $SqlUserPassword
            SqlReferenceDataPassword       = $SqlUserPassword
            SqlMarketingAutomationPassword = $SqlUserPassword
            WdpSkip                        = @{ "objectName" = "iisApp" }, @{"objectName" ="setAcl"}
            Tasks                          = @("InstallWDP")
        }
        Install-SitecoreConfiguration @xconnectParams
    }
}
