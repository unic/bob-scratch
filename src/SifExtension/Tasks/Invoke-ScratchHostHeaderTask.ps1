<#
.SYNOPSIS
Task to create host headers for an IIS web site.
.DESCRIPTION
Creates the IIS Site and IIS Application Pool for the current Sitecore Website
project and adds all host-names to the hosts file. Additionally it creates an
SSL certificate for every HTTPS binding specified in the Bob.config.
Enable-ScSite will also add the "NT Authority\Service" group as administrator to
the SQL server.

.EXAMPLE
Enable-ScSite
#>

Set-StrictMode -Version 2.0

Function Invoke-ScratchHostHeaderTask
{
    [CmdletBinding(SupportsShouldProcess=$false)]
    Param(
        [psobject[]] $Bindings,
        [string] $SiteName,
        [string] $HostsFileComment
    )
    Begin{}

    Process
    {
        $hostFilePath = Join-Path -Path $($env:windir) -ChildPath "system32\drivers\etc\hosts"
        if (-not (Test-Path -Path $hostFilePath)) {
            Throw "Hosts file not found"
        }

        $ipHash = @{}

        foreach($ipHostName in $Bindings) {
            $ip = $ipHostName.IpAddress
            if ($ip -match "\*") {
                Write-Warning "IP $ip contains asterisk and will not be written to the hosts file."
                continue;
            }
            $hostName = $ipHostName.Hostheader
            if($ipHash[$hostName] -and $ipHash[$hostName] -ne $ip) {
                Write-Warning "Hostname $hostName has multiple IPs. The IP $ip will not be written to the hosts file."
                continue;
            }
            $ipHash[$hostName] = $ip

            $hostFile = Get-Content -Path $hostFilePath
            $hostFile = $hostFile -split '[\r\n]'

            $hostFileEntryExist = $false;

            [string[]]$newHostFile = @()

            $hostFileRegex = "^((?:\d\d?\d?\.){3}\d\d?\d?)\s*(.+?)(#.*)?$"

            foreach($line in $hostFile) {
                if($line -match $hostFileRegex) {
                    $lineIp = $matches[1]
                    $lineHost = $matches[2].Trim()
                    if($lineHost -eq $hostName) {
                        if($ip -eq $lineIp) {
                            $newHostFile += $line
                            $hostFileEntryExist = $true
                            Write-TaskInfo -Message "$hostName with $ip exists already" -Tag "Exists"
                        }
                        else {
                            Write-TaskInfo -Message "$hostName has currently the IP $lineIp in the hosts file. This will be overwritten by the new IP $ip" -Tag "Change"
                            $newHostFile += "#" +  $line
                        }
                    }
                    else {
                        $newHostFile += $line                        
                    }
                }
                else {
                    $newHostFile += $line
                }
            }

            if(-not $hostFileEntryExist) {
                $newHostFile +=  "$ip       $($hostName) # Site: $($SiteName) - $($HostsFileComment)"
                Write-TaskInfo -Message "$hostName with $ip" -Tag "Added"

                [System.IO.File]::WriteAllLines($hostFilePath, $newHostFile)                
            }
        }
    }
}

Register-SitecoreInstallExtension -Command Invoke-ScratchHostHeaderTask -As HostHeader -Type Task -Force