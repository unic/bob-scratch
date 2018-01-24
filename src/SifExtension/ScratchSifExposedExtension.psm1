$ErrorActionPreference = "Stop"

$PSScriptRoot = Split-Path  $script:MyInvocation.MyCommand.Path

Get-ChildItem -Path $PSScriptRoot\**\Exposed\*.ps1 -Recurse -Exclude *.tests.ps1 | Foreach-Object { . $_.FullName }
Export-ModuleMember -Function * -Alias *

$VerbosePreference = "Continue"