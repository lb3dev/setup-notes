# Windows 10 Setup Notes for PC Gaming

---

## Windows 10 USB Media Creation Tool

https://www.microsoft.com/en-ca/software-download/windows10ISO

## Installation Notes

### Local Account (Windows 11)

Press Shift + F10 for cmd prompt during setup, at network setup:

```shell
oobe\bypassnro
```
OR
```shell
start ms-cxh:localonly
```

25H2 (Initial setup screen):

```shell
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE /v BypassNRO /t REG_DWORD /d 1 /f
shutdown /r /t 0
```

#### Drive Reservations

- 100GB for C Drive (Windows OS)
- 120GB for D Drive (Main applications)
- Rest for Data / Misc Drives

#### MB Numbers for Drives

- C: 103015MB (599MB System Reserves + 16MB Reserve + 100GB Allocation)
- D: 102400MB (120GB Allocation)

## Initial Setup

- Select Region:
  - US or Canada
- Keyboard Layout: US
  - Skip second keyboard layout setup

Restart Prompt

- How would you like to setup:
  - Personal Use
- Name of person to use this PC:
  - Personal Name
- Setup Password and Confirm
- Setup 3 Security Questions
- Do more with your voice:
  - Don't use online speech recognition
- Let Microsoft and apps use your location:
  - No
- Find my device:
  - No
- Diagnostic data to Microsoft:
  - Only Required
- Improve inking and typing:
  - No
- Get tailored experiences with diagnostic data:
  - No
- Let apps use advertising ID:
  - No
- Let Cortana help you get things done:
  - Not Now

Welcome Screen (This might take several minutes)

Restart Computer (Manually right after landing in Windows)

## Post Installation Notes

#### Enable High Refresh Rates for Monitors

Right Click > Display Settings > Advanced display settings > Update refresh rates

#### Start Menu

###### Disable Web Searches

This will disable any text searches in the Start search menu to not search Bing, and only show local items

Start > WIndows Powershell, complete these regedit value changes

```powershell
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "CortanaConsent" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "AllowSearchToUseLocation" -Type DWord -Value 0
```

#### Firewalls

###### Enable Firewall & network protection

Start > Firewall & network protection > Enable firewalls for all 3 options (Domain network, Private network, and Public network)

#### Network Sharing

###### Disable Share Across Devices

Start > Share across devices > Off

###### Disable Network Discovery And File & Printer Sharing

Start > Manage advanced sharing settings > Turn off for both network discovery and file and printer sharing

(Repeat the step above for Private, Guest or Public, and All Networks)

#### Windows Update

###### Enable and Download Latest Window Updates

Install all the updates first, and then reboot the computer

Start > Windows Update

###### Change Active Hours

Such that Windows will not automatically restart

Start > Windows Update > Change active hours > 6:00 AM to 4:00 AM (Your preference)

#### Automatic Driver Installations

###### Disable Automatic Driver Installations by Windows (Optional)

Only for if you don't want Windows to automatically install drivers for hardware, for example graphics drivers that Windows pulls in will always be outdated compared to the latest releases

Start > Control Panel > System and Security > System > Advanced system settings > Hardware > Device Installation Settings > No

#### Microphone

###### Disable Microphone Access (Optional)

Start > Microphone private settings > Allow apps to access your microphone > Off > Allow desktop apps to access your microphone > Off

#### Mouse

###### Set Pointer Speed

Start > Mouse settings > Set cursor speed to 6 (no scaling)

###### Disable Mouse Acceleration

Start > Mouse settings > Additional mouse options > Pointer Options > Uncheck Enhance pointer precision

## Essential Programs

#### Browsers

###### Firefox

https://www.mozilla.org/en-CA/firefox/new

- Install uBlock Origin addon. Enable addon to run in incognito pages

- Install Bitwarden addon

- Options > Home > Firefox Home Content, disable all pages (optional)

- Options > General > Browsing > Uncheck Enable picture-in-picture video controls

- Import saved Firefox bookmarks

###### Google Chrome

https://www.google.com/chrome

- Import saved Google Chrome bookmarks

#### Hardware / Firmware

###### AMD Radeon Adrenaline Software (GPU Driver)

https://www.amd.com/en/support

Search for your GPU product, after selecting it will redirect to a driver page for example:

https://www.amd.com/en/support/graphics/radeon-500-series/radeon-rx-500-series/radeon-rx-580

Under Windows 10, Choose to download Radeon Software (Download the Second option Recommended (stable), the Optional option is beta version)

###### MSI Afterburner + RivaTuner Overlay

https://www.msi.com/Landing/afterburner

- Settings > General > General properties > Check Start with Windows and Start minimized

- Settings > Fans > Enable user defined fan control > Set custom fan curve
  
  - Set fan speed update period to 2000 ms
  
  Sample graph points (Celsius/%):
  
  - 30/30
  
  - 50/40
  
  - 70/75
  
  - 100/90

- Settings > Monitoring > Add customized sensors to show in OSD
  
  Sample sensors to include:
  
  - GPU1 temperature
  
  - GPU1 usage
  
  - GPU1 memory usage
  
  - GPU1 core clock
  
  - GPU1 fan speed
  
  - CPU temperature
  
  - CPU usage
  
  - CPU clock
  
  - Framerate

- Settings > On-Screen Display > Set Toggle On-Screen Display hotkey (Alt + D for example)

###### VIA (Keyboard Firmware Configurator)

Custom keyboards configuration program

https://caniusevia.com

#### Game Launchers

###### Steam

https://store.steampowered.com

- Settings > Downloads > Verify correct Download Region

- Settings > Library > Check Low Bandwidth Mode (Disable loading community posts in game details pages)

- Settings > In-Game > Disable Steam Overlay while in-game

- Settings > In-Game > Disable Big Picture Overlay

###### Epic Games

https://www.epicgames.com/store/en-US

###### Ubisoft Connect (UPlay)

https://ubisoftconnect.com/en-CA

###### Xbox Game Pass PC

Start > Microsoft Store > Xbox (App)

###### Amazon (Twitch) Games

Download Link:

https://download.amazongames.com/AmazonGamesSetup.exe

Support article:

https://www.amazongames.com/en-us/support/prime-gaming/gf25r2a8vvfhxtqw/articles/download-and-install-the-amazon-games-app/gnt5xgk748qmfxxj

#### Communications

###### Discord

https://discord.com/download

###### OBS

https://obsproject.com

#### Miscellaneous

###### Sublime Text 3

https://www.sublimetext.com

###### VirtualBox

###### Inkscape + GhostScript Plugin
