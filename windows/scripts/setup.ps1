$CurrentDate = Get-Date -Format "yyyy-MM-dd_hh-mm-ss"

Start-Transcript -Path ".\transcript-${CurrentDate}.txt"

Get-ChildItem -Path ".\modules.psm1" | Import-Module -Force

InitialSetup
RegeditCustomizations

Stop-Transcript