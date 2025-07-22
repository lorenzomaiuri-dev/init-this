Write-Host "Starting full setup..."

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script needs to be executed as Admin." -ForegroundColor Red
    exit
}

# --- Set Execution Policy ---
Write-Host "Setting PowerShell execution policy..."
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# TODO: WINGET SETUP

Write-Host "Checking for winget updates..." -ForegroundColor Cyan

# Check current winget version
$wingetVersion = winget --version
Write-Host "Current winget version: $wingetVersion"

# Try to upgrade winget itself
try {
    Write-Host "Attempting to upgrade winget..."
    winget upgrade --id Microsoft.Winget.Source --accept-package-agreements --accept-source-agreements -h
    Write-Host "Winget upgrade completed (if any updates were available)."
} catch {
    Write-Host "Winget upgrade failed or no update available: $_" -ForegroundColor Yellow
}


function Run-Script {
    param (
        [string]$Path
    )

    if (Test-Path $Path) {
        Write-Host "Running $Path..."
        & $Path
    } else {
        Write-Host "Script not found: $Path" -ForegroundColor Yellow
    }
}

Run-Script "./00-system.ps1"
Run-Script "./10-winget.ps1"
Run-Script "./20-config.ps1"
Run-Script "./30-devtools.ps1"
Run-Script "./40-postinstall.ps1"


Write-Host "Setup completed successfully!"
