Start-Transcript -Path ".\transcript.txt"

Get-ChildItem -Path ".\modules.psm1" | Import-Module -Force

InitialSetup
RegeditCustomizations

Stop-Transcript