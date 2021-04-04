Start-Transcript -Path ".\transcript.txt"

Get-ChildItem -Path ".\modules.psm1" | Import-Module -Force

InitialSetup

# Themes

Themes_EnableDarkMode

# Start Menu

StartMenu_DisableWebSearches
StartMenu_DisableLocationAndCortana

# Explorer

Explorer_ShowHiddenFiles
Explorer_ShowFileExtensions

# Mouse

Mouse_SetDefaultSpeed
Mouse_DisableEnhancePointerPrecision

# Delivery Optimization

DeliveryOptimization_DisableAllowDownloadsFromOtherPC

Stop-Transcript