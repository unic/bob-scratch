<#
.SYNOPSIS
Initialize shards in ShardMapManager database.

.DESCRIPTION
Initialize shards in ShardMapManager database.

.EXAMPLE
Invoke-SifXConnectShards -ConfigPath "xconnect-xp0.json" -Sitename "$prefix.xconnect" -SqlDbPrefix $prefix `
    -SqlServer "localhost" -SqlAdminUser "sa" -SqlAdminPassword "sa"

.NOTES
Webiste and database have to be installed first because of reference to App_Data\jobs\continuous\collectiondeployment content and ShardMapManager database.

#>
function Invoke-SifXConnectShards {
    [CmdletBinding()]
    Param(
        [string] $ConfigPath,
        [string] $Sitename,
        [string] $SqlDbPrefix,
        [string] $SqlServer,
        [string] $SqlAdminUser,
        [string] $SqlAdminPassword    
    )
    Process {

        $xconnectParams = @{
            Path             = $ConfigPath
            Sitename         = $Sitename
            SqlDbPrefix      = $SqlDbPrefix
            SqlServer        = $SqlServer
            SqlAdminUser     = $SqlAdminUser
            SqlAdminPassword = $SqlAdminPassword
            Tasks            = @("CleanShards", "CreateShards")
        }
        Install-SitecoreConfiguration @xconnectParams
    }
}
