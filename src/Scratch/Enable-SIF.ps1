function Enable-SIF {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string] $SifPath,
        [Parameter(Mandatory = $true)]
        [string] $FundamentalsPath
    )
    Process {
        Import-Module $FundamentalsPath -force
        Import-Module $SifPath -force
    }
}