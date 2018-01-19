Set-StrictMode -Version 2.0

Function Invoke-ManageExistingAppPoolTask {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Name,
        [Parameter(Mandatory=$true)]
        [ValidateSet('start', 'stop', 'restart')]
		[string]$Action
    )

    if (Test-Path IIS:\AppPools\$Name) {
        Invoke-ManageAppPoolTask -Name $Name -Action $Action
    }
}

Register-SitecoreInstallExtension -Command Invoke-ManageExistingAppPoolTask -As ManageExistingAppPool -Type Task