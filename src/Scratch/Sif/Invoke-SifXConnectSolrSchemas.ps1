<#
.NOTES
Webiste has to be installed first because of reference to App_data\solrcommands\schema.json

.EXAMPLE
Invoke-SifXConnectSolrSchemas -ConfigPath "xconnect-xp0.json" -Sitename "$prefix.xconnect" `
    -SolrUrl "https://localhost:8989/solr" -SolrCorePrefix  $prefix

#>
function Invoke-SifXConnectSolrSchemas {
    [CmdletBinding()]
    Param(
        [string] $ConfigPath,
        [string] $Sitename,
        [string] $SolrUrl,
        [string] $SolrCorePrefix
    )
    Process {

        $xconnectParams = @{
            Path           = $ConfigPath
            Sitename       = $Sitename
            SolrURL        = $SolrUrl
            SolrCorePrefix = $SolrCorePrefix
            Tasks          = @("ConfigureSolrSchemas")
        }             
        Install-SitecoreConfiguration @xconnectParams
    }
}

