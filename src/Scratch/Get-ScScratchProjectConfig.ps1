<#
.SYNOPSIS
Reads the configuration files required for Scratch and returns it as a hashtable

.DESCRIPTION
Reads the configuration files and returns it as a hashtable. Priority will be given to Bob.config and Bob.config.user
If no Bob.config(.user) is found, the Installation.config(.user) will be used.
Per default the config file is taken from the the first config that we come across going from where we are upwards.

.PARAMETER ProjectPath
The path of the project for which the config should be read.
If not provided the current Visual Studio project or the *.Website project will be used.

.EXAMPLE
Get-ScScratchProjectConfig

.EXAMPLE
Get-ScScratchProjectConfig -ProjectPath D:\projects\Spider\src\Spider.Website
#>

Function Get-ScScratchProjectConfig
{
    [CmdletBinding()]
    Param(
        [String]$ProjectPath = ""
    )
    
    Process
    {
        $configFileName = @("Bob.config", "Bob.config.user")
        $ProjectPath = Get-ScProjectPath -ProjectPath $ProjectPath -ConfigFileName $configFileName

        if(-not $ProjectPath) {
            $configFileName = @("Installation.config", "Installation.config.user")
            $ProjectPath = Get-ScProjectPath -ProjectPath $ProjectPath -ConfigFileName $configFileName
        }

        return Get-ScProjectConfig -ProjectPath $ProjectPath -ConfigFileName $configFileName
    }
}
