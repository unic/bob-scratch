function Enable-SIF {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string] $SifPath,
        [Parameter(Mandatory = $true)]
        [string] $FundamentalsPath
    )
    Process {
        Import-Module $FundamentalsPath
        Import-Module $SifPath
    }
}