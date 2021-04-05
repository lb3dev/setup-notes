# Module Variables

[String]$PackagesDrive = "D:\"
$DownloadsFolder = $null
$Packages = $null

# Common Utility Functions

function Write-TagOutput() {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$Tag,
        [Parameter(Mandatory)]
        [String]$Message
    )

    Write-Output "[${Tag}] ${Message}"
}

function Write-SetupOutput() {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$Message
    )

    Write-TagOutput -Tag "Setup" -Message $Message
}

function CheckAdminRights() {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    return (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

function AddOrUpdateRegeditEntry {
    [CmdletBinding()]
    param (
        [String]$Message,
        [String]$DefaultValues,
        [bool]$Admin = $false,
        [Parameter(Mandatory)]
        [String]$Path,
        [Parameter(Mandatory)]
        [String]$Name,
        [Parameter(Mandatory)]
        [String]$Type,
        [Parameter(Mandatory)]
        [Object]$Value
    )

    if ($Message) {
        Write-Output $Message
    }

    if (!(CheckAdminRights) -and $Admin) {
        Write-Output "Skipped. Not running with Administrator rights"
        return
    }

    if (Get-ItemProperty -Path $Path -Name $Name -ErrorAction SilentlyContinue) {
        Set-ItemProperty -Path $Path -Name $Name -Type $Type -Value $Value 
    } else {
        New-ItemProperty -Path $Path -Name $Name -Type $Type -Value $Value
    }

    Write-Output "-Path ${Path} -Name ${Name} -Type ${Type} -Value ${Value} $DefaultValues"
}

function EdgeOpenUrl {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$Url
    )

    Write-TagOutput -Tag "Edge" -Message "Navigating to: ${Url}"
    Start-Process "microsoft-edge:${Url}" -WindowStyle maximized
}

function CreateDirectory() {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$Path,
        [Parameter(Mandatory)]
        [String]$Name
    )

    $Directory = Join-Path -Path $Path -ChildPath $Name

    if (!(Test-Path -Path $Directory)) {
        Write-TagOutput -Tag "Directory" -Message "Created directory: ${Directory}"
        New-Item -ItemType Directory -Path $Directory | Out-Null
    } else {
        Write-TagOutput -Tag "Directory" -Message "${Directory} already exists"
    }
}

function PromptProceed() {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$Message
    )
    $ProceedInput = Read-Host "Continue with: ${Message}? (y/n)"
    return $ProceedInput -eq 'y'
}

function LoadPackages() {
    $json = (Get-Content ".\packages.json" -Raw) | ConvertFrom-Json
    $script:Packages = $json.Packages
    Write-SetupOutput "Loaded packages.json from current directory"
}

function BuildPackagesFolders() {
    $PackagesDirectory = "Packages"
    CreateDirectory -Path $script:PackagesDrive -Name "Arts"
    CreateDirectory -Path $script:PackagesDrive -Name "Downloads"
    CreateDirectory -Path $script:PackagesDrive -Name "GPU Profiles"
    CreateDirectory -Path $script:PackagesDrive -Name $PackagesDirectory

    $script:DownloadsFolder = Join-Path -Path $script:PackagesDrive -ChildPath "Downloads"

    $PackagesPath = Join-Path -Path $script:PackagesDrive -ChildPath $PackagesDirectory

    ForEach ($Package in $Packages) {
        CreateDirectory -Path $PackagesPath -Name $Package.package
    }
}

function PromptDriveLetter() {
    Write-SetupOutput "Here are the current drives on the system:"
    Get-PSDrive -PSProvider FileSystem
    $DriveLetter = Read-Host "Enter the drive letter to create folder scaffolding"
    $DrivePath = "${DriveLetter}:\"
    if (Test-Path -Path $DrivePath) {
        $script:PackagesDrive = $DrivePath
        Write-SetupOutput "$DrivePath selected to create folder scaffolding"
    } else {
        Write-SetupOutput "Bad drive letter! Exiting session with error"
        Exit 1
    }
}

function InstallEdgeExtensions() {
    if (!(PromptProceed -Message "Install Edge Extensions")) {
        return
    }
    # Bitwarden
    EdgeOpenUrl -Url "https://microsoftedge.microsoft.com/addons/detail/bitwarden-free-password/jbkfoedolllekgbhcbcoahefnbanhhlh?hl=en-US"
    # uBlock Origin
    EdgeOpenUrl -Url "https://microsoftedge.microsoft.com/addons/detail/ublock-origin/odfafepnkmbhccpbejgmiehpchacaeak?hl=en-US"
    # Google Drive
    EdgeOpenUrl -Url "https://drive.google.com/drive/my-drive"
}

function DownloadPackages() {
    if (!(PromptProceed -Message "Download Packages")) {
        return
    }

    ForEach ($Package in $Packages) {
        $PackageName = $Package.package
        Write-SetupOutput "Processing Package: ${PackageName}"
        $UrlOpened = $false
        $PackageFile = Join-Path -Path $script:DownloadsFolder -ChildPath $Package.file
        $Counter = 150
        while ($Counter -gt 0) {
            $Items = Get-ChildItem $PackageFile -Name -ErrorAction SilentlyContinue
            if ($Items) {
                Write-SetupOutput "Downloaded file: ${Items}"
                break
            } else {
                if (!$UrlOpened) {
                    EdgeOpenUrl -Url $Package.url
                    Write-SetupOutput "Waiting for download: ${PackageFile}"
                    $UrlOpened = $true
                }
            }
            Start-Sleep -Seconds 2
            $Counter--
        }

        if ($Counter -eq 0) {
            Write-SetupOutput "Unable to download in the session timeframe: ${PackageFile}"
        }
    }

    $ZippedPackages = Get-ChildItem $script:DownloadsFolder -Filter "*.zip"
    ForEach ($ZippedPackage in $ZippedPackages) {
        $ZippedFullname = $ZippedPackage.FullName
        $ZippedDestination = Join-Path -Path $script:DownloadsFolder -ChildPath $ZippedPackage.BaseName
        Write-SetupOutput "Unzipping: ${ZippedFullname} to ${ZippedDestination}"
        Expand-Archive -Path $ZippedFullname -DestinationPath $ZippedDestination -Force
    }
}

function InitialSetup() {
    if (!(PromptProceed -Message "Initial Setup (Create Folders, Download Packages)")) {
        return
    }

    LoadPackages
    PromptDriveLetter
    BuildPackagesFolders
    InstallEdgeExtensions
    DownloadPackages
}

# Themes

function Themes_EnableDarkMode {
    AddOrUpdateRegeditEntry -Message "[Themes] Enable Dark Mode" `
                            -DefaultValues "(Dark = 0, Light = 1)" `
                            -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" `
                            -Name "AppsUseLightTheme" `
                            -Type DWord `
                            -Value 0
}

# Start Menu

function StartMenu_DisableWebSearches {
    AddOrUpdateRegeditEntry -Message "[Start Menu] Disable Web Searches" `
                            -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" `
                            -Name "BingSearchEnabled" `
                            -Type DWord `
                            -Value 0
}

function StartMenu_DisableLocationAndCortana {
    AddOrUpdateRegeditEntry -Message "[Start Menu] Disable Cortana" `
                            -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" `
                            -Name "CortanaConsent" `
                            -Type DWord `
                            -Value 0
    AddOrUpdateRegeditEntry -Message "[Start Menu] Disable Location" `
                            -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" `
                            -Name "AllowSearchToUseLocation" `
                            -Type DWord `
                            -Value 0
}

# File Explorer

function Explorer_ShowHiddenFiles {
    AddOrUpdateRegeditEntry -Message "[Explorer] Show Hidden Files" `
                            -DefaultValues "(Show = 1, Hide = 2)" `
                            -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
                            -Name "Hidden" `
                            -Type DWord `
                            -Value 1
}

function Explorer_ShowFileExtensions {
    AddOrUpdateRegeditEntry -Message "[Explorer] Show File Extensions" `
                            -DefaultValues "(Show = 0, Hide = 1)" `
                            -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
                            -Name "HideFileExt" `
                            -Type DWord `
                            -Value 0
}

function Mouse_SetDefaultSpeed {
    AddOrUpdateRegeditEntry -Message "[Mouse] Set Default Speed" `
                            -DefaultValues "(Range 0-20)" `
                            -Path "HKCU:\Control Panel\Mouse" `
                            -Name "MouseSensitivity" `
                            -Type String `
                            -Value 6
}

function Mouse_DisableEnhancePointerPrecision {
    AddOrUpdateRegeditEntry -Message "[Mouse] Disable Enhance Pointer Precision (Mouse Acceleration)" `
                            -DefaultValues "(Enabled = 1, Disabled = 0)" `
                            -Path "HKCU:\Control Panel\Mouse" `
                            -Name "MouseSpeed" `
                            -Type String `
                            -Value 0
    AddOrUpdateRegeditEntry -DefaultValues "(Enabled = 6, Disabled = 0)" `
                            -Path "HKCU:\Control Panel\Mouse" `
                            -Name "MouseThreshold1" `
                            -Type String `
                            -Value 0
    AddOrUpdateRegeditEntry -DefaultValues "(Enabled = 10, Disabled = 0)" `
                            -Path "HKCU:\Control Panel\Mouse" `
                            -Name "MouseThreshold2" `
                            -Type String `
                            -Value 0
}

function DeliveryOptimization_DisableAllowDownloadsFromOtherPC {
    AddOrUpdateRegeditEntry -Message "[Delivery Optimization] Disable Allow Downloads From Other PCs" `
                            -DefaultValues "(Enabled = 1, Disabled = 0)" `
                            -Admin $true `
                            -Path "Registry::HKEY_USERS\S-1-5-20\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings" `
                            -Name "DownloadMode" `
                            -Type DWord `
                            -Value 0

    Write-Output "[Delivery Optimization] Deleting Delivery Optimization Cache..."
    Delete-DeliveryOptimizationCache -Force
}

function RegeditCustomizations() {
    if (!(PromptProceed -Message "Regedit Customizations")) {
        return
    }

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
}

Export-ModuleMember -Function * -Variable *