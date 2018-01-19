
function Install-XConnectSolrCores {
    [CmdletBinding()]
    Param(
        [string] $Prefix,
        [string] $ConfigPath = "d:\asia\scratch\xconnect-solr.json",
        [string] $SolrUrl = "https://localhost:8989/solr",
        [string] $SolrRoot = "C:\Solr-6.6.2",
        [string] $SolrService = "solr6"
    )
    Process {
        $xconnectParams = @{
            Path        = $ConfigPath
            SolrUrl     = $SolrUrl
            SolrRoot    = $SolrRoot
            SolrService = $SolrService
            CorePrefix  = $prefix
        }
        Install-SitecoreConfiguration @xconnectParams
    }
}
