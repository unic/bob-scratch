$ErrorActionPreference = "Stop"

$PSScriptRoot = Split-Path  $script:MyInvocation.MyCommand.Path

Get-ChildItem -Path $PSScriptRoot\*.ps1 -Recurse -Exclude Exposed\*.ps1,*.tests.ps1 | Foreach-Object { . $_.FullName }

$VerbosePreference = "Continue"