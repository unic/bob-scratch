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

    # Pass verbose on if required
    $verbose = $false
    if($PSBoundParameters.ContainsKey('Verbose')) {
        $verbose = $PSBoundParameters["Verbose"]
    }

    $found = Invoke-GetCertificateConfigFunction -Id $Id -CertStorePath $CertStorePath -Verbose:$verbose -WarningAction SilentlyContinue
    if ($found) { return $found.Thumbprint }
    return "notfound"
}

Register-SitecoreInstallExtension -Command Invoke-TryGetCertificateThumbprintConfigFunction -As TryGetCertificateThumbprint -Type ConfigFunction