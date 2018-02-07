#Requires -Modules WebAdministration

Set-StrictMode -Version 2.0

AssertWebAdministration -ScriptName $MyInvocation.MyCommand.Name

function Invoke-ScratchWebBindingTask {
    [CmdletBinding(SupportsShouldProcess=$false)]
    param(
        [Parameter(Mandatory=$true)]
        [string]$SiteName,
        [psobject[]]$Add = @(),
        [psobject[]]$Remove = @(),
        [psobject[]]$Update = @()
    )

    function SetCert {
        param(
            [Parameter(Mandatory=$true)]
            [psobject]$Entry,
            [Parameter(Mandatory=$true)]
            [string]$Thumbprint
        )

        $binding = Get-WebBinding -Name $SiteName @entry
        $expectedPath = 'Cert:\LocalMachine\my'
        $cert =  Get-ChildItem $expectedPath -recurse | Where-Object { $_.Thumbprint -eq $Thumbprint }

        if(-not $cert) {
            throw "Certificate with thumbprint '$Thumbprint' could not be found at $expectedPath"
        }
        $store = $cert.PSParentPath.Substring($cert.PSParentPath.LastIndexOf('\')+1)

        $binding.AddSslCertificate($cert.Thumbprint, $store)
    }

    try {
        $site = Get-Item IIS:\sites\$Sitename -ErrorAction SilentlyContinue
        if(!$site){
            throw "Could not find site: $SiteName"
        }

        # REMOVE
        # Special case for '*' in remove that removes all
        if($Remove.Contains('*')) {
            Write-Verbose "Removing all web bindings for $siteName"
            if($entry = '*') {
                $bindings = Get-WebBinding -Name $siteName
                if($bindings) {
                    Write-TaskInfo -Message ($bindings | Out-String) -Tag 'RemoveAll'
                    $bindings | Remove-WebBinding
                } else {
                    Write-Warning -Message "No current bindings for site $SiteName"
                }
            }
        } else {
            foreach($entry in $Remove) {
                $entry.GetEnumerator() | ForEach-Object { Write-Verbose "Removing $siteName web binding: $($_.Key)=$($_.Value)" }
                $bindings = Get-WebBinding -Name $SiteName @entry
                if(!$bindings){
                    "Web Binding does not exist for $SiteName",$entry | Out-String | Write-Warning
                } else {
                    Write-TaskInfo -Message ($bindings | Out-String) -Tag 'Remove'
                    $bindings | Remove-WebBinding
                }
            }
        }

        # ADD
        foreach($entry in $Add){
            $thumbprint = $null
            if($entry.Contains('Thumbprint')){
                $thumbprint = $entry.Thumbprint
                Write-Verbose "Web binding being added contains thumbprint: $thumbprint"
                $entry.Remove('Thumbprint')
            }

            $sslFlags = 0
            if($entry.Contains('SSLFlags')) {
                $sslFlags = $entry.SSLFlags
                Write-Verbose "Web binding being added contains SSL Flags: $sslFlags"
                $entry.Remove('SSLFlags')
            }

            if($entry.Contains('IpAddress')) {
                $ip = $entry.IPAddress
                Write-Verbose "Web binding being added contains IP Address: $ip"
                $entry.Remove('IpAddress')
            }

            if(Get-WebBinding -Name $SiteName @entry){
                "Web Binding already exists for $SiteName",$entry | Out-String | Write-Warning
            } else {
                Write-TaskInfo -Message ($entry | Out-String) -Tag 'Add'
                New-WebBinding -Name $SiteName @entry -SslFlags $sslFlags -IPAddress $ip

                if($thumbprint) {
                    Write-Verbose "Setting SSL Certificate"
                    SetCert -Entry $entry -Thumbprint $thumbprint
                }
            }
        }

        # Update
        foreach($entry in $Update){

            $thumbprint = $null
            if($entry.Contains('Thumbprint')){
                $thumbprint = $entry.Thumbprint
                Write-Verbose "Web binding being updated contains thumbprint: $thumbprint"
                $entry.Remove('Thumbprint')
            }

            Write-TaskInfo -Message ($entry | Out-String) -Tag 'Update'
            Set-WebBinding -Name $SiteName @entry

            foreach($key in 'Property','Value') {
                $entry.Remove($key)
            }

            if($thumbprint) {
                Write-Verbose "Setting SSL Certificate"
                SetCert -Entry $entry -Thumbprint $thumbprint
            }
        }
    } catch {
        Write-Error $_
    }
}

Register-SitecoreInstallExtension -Command Invoke-ScratchWebBindingTask -As WebBinding -Type Task