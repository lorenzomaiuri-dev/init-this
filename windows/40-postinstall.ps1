Write-Host "Running post-install cleanup and optimizations..." -ForegroundColor Cyan

# Clear Windows Update cache
Write-Host "Clearing Windows Update cache..."
Stop-Service wuauserv -Force
Remove-Item -Path "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
Start-Service wuauserv

# Clear temp files
Write-Host "Clearing temporary files..."
Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue

# Clean winget cache
Write-Host "Cleaning winget cache..."
Remove-Item "$env:LOCALAPPDATA\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalCache\*" -Recurse -Force -ErrorAction SilentlyContinue

Clear-History

# TODO: privay.sexy
# use various external tools https://pastebin.com/S5VKBirt

Write-Host "Post-install cleanup and tweaks completed."

Write-Host "It is recommended to restart your computer to apply all changes." -ForegroundColor Yellow
