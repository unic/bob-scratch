<#
.SYNOPSIS
Initialize shards in ShardMapManager database.

.DESCRIPTION
Initialize shards in ShardMapManager database.

.EXAMPLE

.NOTES
Webiste and database have to be installed first because of reference to App_Data\jobs\continuous\collectiondeployment content and ShardMapManager database.

#>
function Install-XConnectShards {
    [CmdletBinding()]
    Param(
        [string] $Prefix,
        [string] $ConfigPath = "d:\asia\scratch\xconnect-xp0.json",
        [string] $PackagePath = "d:\asia\scratch\Sitecore9_xp0xconnect.scwdp.zip"        
    )
    Process {

        $xconnectParams = @{
            Path             = $ConfigPath
            Sitename         = "$prefix.xconnect"
            SqlDbPrefix      = $prefix
            SqlServer        = "localhost"
            SqlAdminUser     = "sa"
            SqlAdminPassword = "sa"
            Tasks            = @("CleanShards", "CreateShards")
        }
        Install-SitecoreConfiguration @xconnectParams
    }
}
