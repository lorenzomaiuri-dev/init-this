Write-Host "Configuring development environment..." -ForegroundColor Cyan

# --- Git configuration ---
Write-Host "Configuring Git..."
git config --global user.name "Lorenzo Maiuri"
git config --global user.email "maiurilorenzo@gmail.com"
git config --global core.autocrlf input
git config --global credential.helper manager-core
git config --global init.defaultBranch main
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global core.editor "code --wait"

# --- PowerShell profile setup ---
Write-Host "Setting up PowerShell profile..."

$profilePath = $PROFILE.CurrentUserAllHosts
Write-Host "PowerShell profile path: $profilePath"

$profileContent = @"
Import-Module oh-my-posh
Set-PoshPrompt -Theme paradox

# Custom Aliases
Set-Alias gs git status
Set-Alias gc git commit
Set-Alias gp git push

# PSReadLine options
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -PredictionSource History

# Terminal Icons
Import-Module Terminal-Icons

# Environment variables
# $env:MY_ENV_VAR = 'value'
"@

if (-not (Test-Path $profilePath)) {
    New-Item -ItemType File -Path $profilePath -Force | Out-Null
}

if (-not (Get-Content $profilePath | Select-String 'Import-Module oh-my-posh')) {
    Add-Content -Path $profilePath -Value $profileContent -Encoding UTF8
    Write-Host "PowerShell profile updated at $profilePath"
} else {
    Write-Host "PowerShell profile already configured, skipping."
}

# --- Set Execution Policy ---
Write-Host "Setting PowerShell execution policy..."
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# --- Install PowerShell modules ---
Write-Host "Installing PowerShell modules..."

$modules = @("PSReadLine", "Terminal-Icons")
foreach ($mod in $modules) {
    if (Get-Module -ListAvailable -Name $mod) {
        Write-Host "Module $mod already installed"
    } else {
        try {
            Install-Module $mod -Scope CurrentUser -Force -ErrorAction Stop
            Write-Host "Installed module: $mod"
        } catch {
            Write-Host "Failed to install module: $mod — $_" -ForegroundColor Yellow
        }
    }
}

# --- VS Code Extensions ---
Write-Host "Installing VS Code extensions..."

$extensions = @(
    "ms-dotnettools.csharp",
    "ms-python.python",
    "ms-vscode.cpptools",
    "esbenp.prettier-vscode",
    "ms-azuretools.vscode-docker",
    "redhat.vscode-yaml",
    "ms-azuretools.vscode-kubernetes-tools",
    "eamodio.gitlens",
    "visualstudioexptteam.vscodeintellicode"
)

if (Get-Command code -ErrorAction SilentlyContinue) {
    foreach ($ext in $extensions) {
        Write-Host "Installing $ext..."
        code --install-extension $ext --force
    }
} else {
    Write-Host "VS Code CLI not found. Skipping extension installation." -ForegroundColor Yellow
}

# --- WSL Installation and Debian Setup ---
Write-Host "Checking WSL installation..."

$wslFeature = Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
$vmPlatform = Get-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform

if ($wslFeature.State -ne 'Enabled' -or $vmPlatform.State -ne 'Enabled') {
    Write-Host "Enabling WSL and Virtual Machine Platform..."
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart
    Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart
    Write-Host "A reboot is required to complete WSL setup." -ForegroundColor Yellow
} else {
    Write-Host "WSL and Virtual Machine Platform already enabled."
}

# Check if Debian is already installed
$debianInstalled = wsl --list --quiet | Select-String -Pattern "Debian"

if (-not $debianInstalled) {
    Write-Host "Installing Debian for WSL..."
    winget install --id Debian.Debian --source winget --accept-package-agreements --accept-source-agreements
    Write-Host "Debian installed. You may need to launch it manually to complete initialization." -ForegroundColor Green
} else {
    Write-Host "Debian is already installed in WSL."
}

# Set default WSL distro to Debian
Write-Host "Setting Debian as the default WSL distro..."
wsl --set-default Debian


Write-Host "Development environment configuration completed." -ForegroundColor Green
