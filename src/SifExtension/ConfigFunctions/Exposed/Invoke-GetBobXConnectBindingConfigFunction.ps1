Set-StrictMode -Version 2.0

function Invoke-GetBobXConnectBindingConfigFunction {
    [CmdletBinding()]
    param(
    )

    $config = Get-ScProjectConfig -ConfigFileName @("Installation.config", "Installation.config.user")

    $rawBindings = $config.XConnectCollectionServiceUrl

    $bindings = @($rawBindings | % {
            $url = $_.InnerText
            $uri = New-Object System.Uri $url
            $ip = $_.IP
            $ssl = if ($uri.Scheme -eq "https") { 1 } else { 0 }
            $thumbPrint = ""
            if ($ssl) {
                $thumbPrint = Get-ServerCertificateThumbprint -Hostname $uri.Host
            }

            @{
                "HostHeader" = $uri.Authority
                "Protocol"   = $uri.Scheme
                "SSLFlags"   = $ssl
                "IpAddress"  = $ip
                "Thumbprint" = $thumbPrint #"D6364D791F75CC98909F2910071AC97F3B49B86A"  #"local9.xconnect_client" #"D8D5EC123AF6438D7957D005097627EC742005C4"
            }
        })
    

    #    $json = ConvertTo-Json $bindings
    $bindings
}

Register-SitecoreInstallExtension -Command Invoke-GetBobXConnectBindingConfigFunction -As GetBobXConnectBinding -Type ConfigFunction -Force