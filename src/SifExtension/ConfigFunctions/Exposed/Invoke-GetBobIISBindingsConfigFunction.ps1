Set-StrictMode -Version 2.0

function Invoke-GetBobIISBindingsConfigFunction {
    [CmdletBinding()]
    param(
    )

    $config = Get-ScProjectConfig Get-ScScratchProjectConfig

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
            "Thumbprint" = $thumbPrint #"D6364D791F75CC98909F2910071AC97F3B49B86A"  #"local9.xconnect_client"
		}
    })

#    $json = ConvertTo-Json $bindings
    $bindings
}

Register-SitecoreInstallExtension -Command Invoke-GetBobIISBindingsConfigFunction -As GetBobIISBindings -Type ConfigFunction -Force