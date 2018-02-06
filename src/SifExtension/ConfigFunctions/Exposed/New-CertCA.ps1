function New-CertCA {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [string] $Name
    )
    Process {
        $expires = (Get-Date).AddYears(100)

        $cert = New-SelfSignedCertificate -CertStoreLocation cert:\LocalMachine\My -dnsname $Name -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.1", "2.5.29.19={text}CA=true") -KeyUsage CertSign -NotAfter $expires 

        $DestStoreScope = 'LocalMachine'
        $DestStoreName = 'root'

        $DestStore = New-Object -TypeName System.Security.Cryptography.X509Certificates.X509Store -ArgumentList $DestStoreName, $DestStoreScope
        $DestStore.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite)
        $DestStore.Add($cert)

        $DestStore.Close()

        return $cert
    }
}