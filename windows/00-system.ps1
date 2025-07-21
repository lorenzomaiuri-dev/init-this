Write-Host "🔧 Applying basic Windows system configuration..." -ForegroundColor Cyan

function Set-RegValue {
    param (
        [string]$Path,
        [string]$Name,
        [object]$Value
    )

    try {
        if (-not (Test-Path $Path)) {
            New-Item -Path $Path -Force | Out-Null
        }
        Set-ItemProperty -Path $Path -Name $Name -Value $Value -ErrorAction Stop
        Write-Host "✔ Set $Name in $Path to $Value"
    } catch {
        Write-Host "❌ Failed to set $Name in $Path: $_" -ForegroundColor Red
    }
}

function Remove-BloatwareAppx {
    param (
        [string[]]$AppPatterns
    )

    foreach ($pattern in $AppPatterns) {
        Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like "*$pattern*" } | ForEach-Object {
            try {
                Write-Host "🧼 Removing provisioned package: $($_.DisplayName)"
                Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName
            } catch {
                Write-Host "⚠️ Failed to remove provisioned: $($_.DisplayName) — $_"
            }
    }

    }
}


## 🗂️ File Explorer Settings
# Show file extensions
Set-RegValue "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "HideFileExt" 0
# Show hidden files and folders
Set-RegValue "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" "Hidden" 1
# Show full path in title bar
Set-RegValue "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "FullPath" 1
# Set Explorer to open "This PC" instead of Quick Access
Set-RegValue "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "LaunchTo" 1
# Enable "NTFS long paths"
Set-RegValue "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" "LongPathsEnabled" 1


## 🌙 Theme and Appearance
# Enable dark mode for apps and system
Set-RegValue "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" "AppsUseLightTheme" 0
Set-RegValue "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" "SystemUsesLightTheme" 0

## 🔕 Disable annoying content
# Disable suggestions in Start Menu
Set-RegValue "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338387Enabled" 0
Set-RegValue "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "ContentDeliveryAllowed" 0
Set-RegValue "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "FeatureManagementEnabled" 0
# Disable "Welcome Experience"
Set-RegValue "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-310093Enabled" 0
# Disable tips & tricks
Set-RegValue "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338388Enabled" 0
# 🎮 Disable Game Bar / DVR
Set-RegValue "HKCU:\Software\Microsoft\GameBar" "ShowStartupPanel" 0
Set-RegValue "HKCU:\Software\Microsoft\GameBar" "AllowAutoGameMode" 0
Set-RegValue "HKCU:\Software\Microsoft\GameBar" "UseNexusForGameBarEnabled" 0
Set-RegValue "HKCU:\System\GameConfigStore" "GameDVR_Enabled" 0
Set-RegValue "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" "AppCaptureEnabled" 0
# 💬 Disable Feedback Hub
Set-RegValue "HKCU:\Software\Microsoft\Siuf\Rules" "NumberOfSIUFInPeriod" 0
Set-RegValue "HKCU:\Software\Microsoft\Siuf\Rules" "PeriodInDays" 0
# Disable Cortana
Set-RegValue "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" "CortanaConsent" 0
Set-RegValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" "AllowCortana" 0


## 🔒 Privacy & Efficiency
# Disable "Let Windows track app launches"
Set-RegValue "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Start_TrackProgs" 0
Set-RegValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" 0
Set-RegValue "HKCU:\Software\Microsoft\Windows\CurrentVersion\ActivityHistory" "PublishUserActivities" 0
Set-RegValue "HKCU:\Software\Microsoft\Windows\CurrentVersion\ActivityHistory" "AllowCrossDeviceSync" 0
Set-RegValue "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" "Enabled" 0


## 📅 Taskbar & Clock
# Show seconds in taskbar clock (Windows 11+)
Set-RegValue "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ShowSecondsInSystemClock" 1

## 📋 Clipboard & Input
# Set keyboard layout to Italian
Set-RegValue "HKCU:\Keyboard Layout\Preload" "1" "00000410"  # 00000410 = IT (Italian)

# Enable clipboard history
Set-RegValue "HKCU:\Software\Microsoft\Clipboard" "EnableClipboardHistory" 1

# Enable Emoji panel with Win + .
Set-RegValue "HKCU:\Software\Microsoft\Input\Settings" "EnableExpressiveInputShellHotkey" 1

# Remove Bloatware
Write-Host "🧹 Removing preinstalled bloatware..." -ForegroundColor Cyan
$BloatwarePatterns = @(
    "Xbox", "Gaming", "Zune", "Skype", "OneNote", "Solitaire",
    "People", "GetHelp", "Getstarted", "3DBuilder", "Bing", "Weather",
    "Maps", "Wallet", "YourPhone", "FeedbackHub", "MixedReality", "News"
)

Remove-BloatwareAppx -AppPatterns $BloatwarePatterns

# Set Power Plan to High Performance
Write-Host "→ Setting power plan to High Performance..."
$highPerfPlan = powercfg -list | Where-Object { $_ -match "High performance" } | ForEach-Object { ($_ -split ' ')[3] }
if ($highPerfPlan) {
    powercfg -setactive $highPerfPlan
}


Write-Host "✅ Basic system configuration applied." -ForegroundColor Green
