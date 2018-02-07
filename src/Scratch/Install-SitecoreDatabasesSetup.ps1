<#
.SYNOPSIS
Installs Sitecore Databases.

.DESCRIPTION
Installs the databases required for an xp0 instance (does not include xconnect dbs).

.EXAMPLE
Install-SitecoreDatabasesSetup c:\temp\SitecoreInstallFramework c:\temp\SitecoreFundamentals c:\temp\sitecore-XP0.json c:\temp\xp0.scwdp.zip

.NOTES
Requirements for configuration file comparing to default sitecore-XP0.json

#>
function Install-SitecoreDatabasesSetup {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path $_ })]
        [string] $ModuleSifPath,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path $_ })]
        [string] $ModuleFundamentalsPath,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path $_ })]
        [string] $SifConfigPathSitecoreXp0,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path $_ })]
        [string] $SitecorePackagePath
    )
    Process {

        # Load SIF Modules
        Enable-SIF -SifPath $ModuleSifPath -FundamentalsPath $ModuleFundamentalsPath

        # Temporary change location so SIF can find the extensions
        Push-Location $(Split-Path(Split-Path -parent $script:MyInvocation.MyCommand.Path))

        try{
            # Install Sitecore Databases
            Invoke-SifSitecoreDatabases -ConfigPath $SifConfigPathSitecoreXp0 -PackagePath $SitecorePackagePath
        }
        finally{
            # Revert location change
            Pop-Location
        }
    }
}
