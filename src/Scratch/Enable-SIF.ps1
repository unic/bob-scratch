function Enable-SIF {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path $_ })]
        [string] $SifPath,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path $_ })]
        [string] $FundamentalsPath
    )
    Process {
        Import-Module $FundamentalsPath -Global
        Import-Module $SifPath -Global
    }
}