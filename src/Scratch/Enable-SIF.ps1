function Enable-SIF {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string] $SifPath,
        [Parameter(Mandatory = $true)]
        [string] $FundamentalsPath
    )
    Process {
        Import-Module $SifPath -force
        Import-Module $FundamentalsPath -force

        Register-SitecoreInstallExtension -Command Invoke-TryGetCertificateThumbprintConfigFunction -As TryGetCertificateThumbprint -Type ConfigFunction -force
    }
}