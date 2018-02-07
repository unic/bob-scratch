Set-StrictMode -Version 2.0

function Get-XConnectWebsiteUrl {
    [CmdletBinding()]
    param(
    )

    Import-Module .\SifExtension\ScratchSifExposedExtension.psm1 -force
    $bindings = Invoke-GetBobXConnectBindingConfigFunction

    if ($bindings.Count -lt 1) {
        Write-Error -Message "No Binding found."
        return
    }

    $xConnectRootUrl = ""
    if ($bindings.Protocol -ne $null){
        $xConnectRootUrl = "$($bindings.Protocol)://$($bindings.HostHeader)"
    }
    else {
        $xConnectRootUrl = "$($bindings[0].Protocol)://$($bindings[0].HostHeader)"
    }

    $xConnectRootUrl
}