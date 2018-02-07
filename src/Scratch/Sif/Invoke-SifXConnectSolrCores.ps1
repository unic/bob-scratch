<#
.SYNOPSIS
Installs xConnect Solr cores.

.EXAMPLE
Invoke-SifXConnectSolrCores -ConfigPath "xconnect-solr.json" -SolrUrl "https://localhost:8989/solr" `
    -SolrRoot "C:\Solr-6.6.2" -SolrService "solr6" -SolrCorePrefix $prefix
#>
function Invoke-SifXConnectSolrCores {
    [CmdletBinding()]
    Param(
        [string] $ConfigPath,
        [string] $SolrUrl,
        [string] $SolrRoot,
        [string] $SolrService,
        [string] $SolrCorePrefix
    )
    Process {
        $xconnectParams = @{
            Path        = $ConfigPath
            SolrUrl     = $SolrUrl
            SolrRoot    = $SolrRoot
            SolrService = $SolrService
            CorePrefix  = $SolrCorePrefix
        }
        Install-SitecoreConfiguration @xconnectParams
    }
}
