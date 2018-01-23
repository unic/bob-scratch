Set-StrictMode -Version 2.0

function Invoke-GetBobIISBindingsConfigFunction {
    [CmdletBinding()]
    param(
    )

    $config = Get-ScProjectConfig -ConfigFileName @("Installation.config", "Installation.config.user")

    $rawBindings = $config.IISBindings

    $bindings = @($rawBindings | % {
        $url = $_.InnerText
        $uri = New-Object System.Uri $url
        $ip = $_.IP
        $ssl = if ($uri.Scheme -eq "https") { 1 } else { 0 }
        $thumbPrint = ""
        if ($ssl) {
            $thumbPrint = Invoke-GetCertificateThumbprintConfigFunction -Id $uri.Authority
            Write-Host "thumbPrint: $thumbPrint"
        }

        @{
            "HostHeader" = $uri.Authority
            "Protocol" = $uri.Scheme
            "SSLFlags" = $ssl
			"IpAddress" = $ip
            "Thumbprint" = $thumbPrint
		}
    })

#    $json = ConvertTo-Json $bindings
    $bindings
}

Export-ModuleMember -Function Invoke-GetBobIISBindingsConfigFunction

Register-SitecoreInstallExtension -Command Invoke-GetBobIISBindingsConfigFunction -As GetBobIISBindings -Type ConfigFunction