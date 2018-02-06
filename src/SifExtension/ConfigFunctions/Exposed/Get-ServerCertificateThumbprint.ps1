function Get-ServerCertificateThumbprint {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [string] $Hostname
    )
    Process {

        $thumbPrint = Invoke-GetCertificateThumbprintConfigFunction -Id $Hostname
        if (-not $thumbPrint) {
            $cert = New-Cert -Name $Hostname
            if ($cert) {
                Write-TaskInfo -Message "Certificate for $Hostname" -Tag "Added"
                $thumbPrint = $cert.Thumbprint
            }
        }
        $thumbPrint
    }
}