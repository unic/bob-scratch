function New-Cert {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [string] $Name,
        [string] $CaName = "BobScratch",
        [string] $CertStorePath = 'Cert:\LocalMachine\My'
    )
    Process {

        $ca = ls Cert:\LocalMachine\Root | ? {$_.Subject -like "CN=$CaName"}
        if (-not $ca) {
            $ca = New-CertCA $CaName
            Write-Host "Created certificate authority $CaName"
        }

        $expires = (Get-Date).AddYears(100)

        return (New-SelfSignedCertificate -DnsName $Name -CertStoreLocation "cert:\LocalMachine\My" -Signer $ca -NotAfter $expires)
    }
}