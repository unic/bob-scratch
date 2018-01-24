Set-StrictMode -Version 2.0

function Invoke-TryGetCertificateThumbprintConfigFunction {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Id,
        [ValidateScript( { $_ -like 'cert:\*' })]
        [ValidateScript( { Test-Path $_ })]
        [string]$CertStorePath = 'Cert:\LocalMachine\My'
    )

    $thumbprint = Invoke-GetCertificateThumbprintConfigFunction -Id $Id -CertStorePath $CertStorePath -ErrorAction SilentlyContinue
    if (-not($thumbprint)) {
        $thumbprint = "notfound"
    }
    $thumbprint
}

Register-SitecoreInstallExtension -Command Invoke-TryGetCertificateThumbprintConfigFunction -As TryGetCertificateThumbprint -Type ConfigFunction