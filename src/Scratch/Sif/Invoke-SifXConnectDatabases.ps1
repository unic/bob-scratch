<#
.SYNOPSIS
Installs xConnect databases from WebDeploy package

.DESCRIPTION
Installs all databases from WebDeploy package using SIF.

.EXAMPLE


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

function Invoke-SifXConnectDatabases {
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
            SqlDbPrefix                    = $prefix
            SqlServer                      = "localhost"
            SqlAdminUser                   = "sa"
            SqlAdminPassword               = "sa"
            SqlCollectionPassword          = "H6dfVh2QGU"
            SqlProcessingPoolsPassword     = "H6dfVh2QGU"
            SqlReferenceDataPassword       = "H6dfVh2QGU"
            SqlMarketingAutomationPassword = "H6dfVh2QGU"
            WdpSkip                        = @{ "objectName" = "iisApp" }, @{"objectName" ="setAcl"}
            Tasks                          = @("InstallWDP")
        }
        Install-SitecoreConfiguration @xconnectParams
    }
}
