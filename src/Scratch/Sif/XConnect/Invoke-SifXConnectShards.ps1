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
        [string] $ConfigPath
    )
    Process {

        $InstallationConfig = Get-ScScratchProjectConfig

        # Site parameters
        $SiteGlobalWebPath = $InstallationConfig.GlobalWebPath
        $Sitename = $InstallationConfig.XConnectWebsiteCodename 
        $WebFolderName = $InstallationConfig.XConnectWebFoldername
        # Database parameters (used to setup databases)
        $SqlDbPrefix = $InstallationConfig.DatabaseDbPrefix
        $SqlDbServer = $InstallationConfig.DatabaseServer
        $SqlDbSitecoreUserPwd = $InstallationConfig.DatabaseSitecoreDbUserPwd
        
        $SqlAdminUser = $InstallationConfig.DatabaseAdminUser
        $SqlAdminPwd = $InstallationConfig.DatabaseAdminPwd

        $xconnectParams = @{
            Path                  = $ConfigPath
            SiteGlobalWebPath     = $SiteGlobalWebPath
            Sitename              = $Sitename
            WebFolderName         = $WebFolderName
            SqlDbPrefix           = $SqlDbPrefix
            SqlServer             = $SqlDbServer
            SqlAdminUser          = $SqlAdminUser
            SqlAdminPassword      = $SqlAdminPwd
            SqlCollectionPassword = $SqlDbSitecoreUserPwd
            Tasks                 = @("CleanShards", "CreateShards", "CreateShardApplicationDatabaseServerLoginSqlCmd", "CreateShardManagerApplicationDatabaseUserSqlCmd", "CreateShard0ApplicationDatabaseUserSqlCmd", "CreateShard1ApplicationDatabaseUserSqlCmd")
        }
        Install-SitecoreConfiguration @xconnectParams
    }
}
