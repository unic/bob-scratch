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
function Invoke-SifSitecoreWebsiteOctopus {
    [CmdletBinding()]
    Param(
        [string] $ConfigPath,
        [string] $PackagePath,
        [string] $TargetWebDir,
        [string] $SiteName
    )
    Process {

        $sitecoreParams = @{
            Path                           = $ConfigPath
            Package                        = $PackagePath
            SiteGlobalWebPath              = $TargetWebDir
            Sitename                       = $Sitename
            WebFolderName                  = ""
            WdpSkip                        = @{ "objectName" = "dbDacFx" }, @{ "objectName" = "dbFullSql" }
            Tasks                          = @("CreatePaths", "InstallWDP")
        }             
        Install-SitecoreConfiguration @sitecoreParams
    }
}

