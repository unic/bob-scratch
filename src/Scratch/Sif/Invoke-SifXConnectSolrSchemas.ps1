<#
.NOTES
Webiste has to be installed first because of reference to App_data\solrcommands\schema.json

#>
function Invoke-SifXConnectSolrSchemas {
    [CmdletBinding()]
    Param(
        [string] $prefix,
        [string] $ConfigPath = "d:\asia\scratch\xconnect-xp0.json"
    )
    Process {

        $xconnectParams = @{
            Path           = $ConfigPath
            Sitename       = "$prefix.xconnect"
            SolrURL        = "https://localhost:8989/solr"
            Tasks          = @("ConfigureSolrSchemas")
            SolrCorePrefix = $prefix
        }             
        Install-SitecoreConfiguration @xconnectParams
    }
}

