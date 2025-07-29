Write-Host "Installing development tools via winget..." -ForegroundColor Cyan

function Install-App {
    param(
        [string]$Id,
        [string]$Name = $null
    )

    if (-not $Name) {
        $Name = $Id
    }

    $installed = winget list --id $Id --source winget | Select-Object -Skip 1
    if ($installed) {
        Write-Host "$Name is already installed, skipping."
    } else {
        Write-Host "Installing $Name..."
        try {
            winget install --id $Id --silent --accept-package-agreements --accept-source-agreements -ErrorAction Stop
            Write-Host "$Name installed successfully." -ForegroundColor Green
        } catch {
            Write-Host "Failed to install $Name : $_" -ForegroundColor Yellow
        }
    }
}


# Development Essentials
Install-App -Id "Git.Git" -Name "Git"
Install-App -Id "GitHub.GitLFS" -Name "Git LFS"
Install-App -Id "GitHub.cli" -Name "GitHub CLI"
Install-App -Id "Microsoft.DotNet.SDK.8" -Name ".NET SDK 8"
Install-App -Id "Python.Python.3.13" -Name "Python 3.13"
Install-App -Id "astral-sh.uv" -Name "UVX"
Install-App -Id "NVIDIA.CUDA" -Name "CUDA Toolkit"
Install-App -Id "OpenJS.NodeJS.LTS" -Name "Node.js LTS"
Install-App -Id "CoreyButler.NVMforWindows" -Name "NVM for Windows"
Install-App -Id "Yarn.Yarn" -Name "Yarn"
Install-App -Id "Oracle.JavaRuntimeEnvironment" -Name "Java JRE"
Install-App -Id "Microsoft.OpenJDK.21" -Name "Microsoft Build of OpenJDK 21"
Install-App -Id "PHP.PHP.8.4" -Name "PHP 8.4"
Install-App -Id "GoLang.Go" -Name "Go"
Install-App -Id "RubyInstallerTeam.Ruby.3.4" -Name "Ruby 3.4"
Install-App -Id "Rustlang.Rustup" -Name "Rustup"
Install-App -Id "Kitware.CMake" -Name "CMake"
Install-App -Id "GnuWin32.Make" -Name "Make"
Install-App -Id "Microsoft.VisualStudioBuildTools" -Name "Visual Studio Build Tools"


# IDEs & Developer Tools
Install-App -Id "Microsoft.VisualStudioCode" -Name "VS Code"
Install-App -Id "Microsoft.VisualStudio.2022.Community" -Name "Visual Studio 2022 Community"
Install-App -Id "JetBrains.Toolbox" -Name "JetBrains Toolbox"
Install-App -Id "JetBrains.PyCharm.Community" -Name "JetBrains PyCharm Community"
Install-App -Id "Google.AndroidStudio" -Name "Android Studio"
Install-App -Id "Postman.Postman" -Name "Postman"

# Database & Data Tools
Install-App -Id "dbeaver.dbeaver" -Name "DBeaver"
Install-App -Id "DBVis.DBVisualizer" -Name "DBVisualizer"
Install-App -Id "MongoDB.Compass.Community" -Name "MongoDB Compass Community"
Install-App -Id "PostgreSQL.pgAdmin" -Name "pgAdmin"
Install-App -Id "Microsoft.SQLServerManagementStudio" -Name "SQL Server Management Studio"
Install-App -Id "SQLite.SQLite" -Name "SQLite"
Install-App -Id "PostgreSQL.psqlODBC" -Name "PostgreSQL ODBC Driver"
Install-App -Id "Microsoft.msodbcsql.18" -Name "SQL Server ODBC Driver"

# Cloud & DevOps Tools
Install-App -Id "Microsoft.AzureCLI" -Name "Azure CLI"
Install-App -Id "Google.CloudSDK" -Name "Google Cloud SDK"
Install-App -Id "Amazon.AWSCLI" -Name "AWS CLI"
Install-App -Id "Hashicorp.Terraform" -Name "Terraform"
Install-App -Id "OpenVPNTechnologies.OpenVPNConnect" -Name "OpenVPNConnect"
Install-App -Id "Ngrok.Ngrok" -Name "ngrok"

# Containerization / Virtualization
Install-App -Id "Docker.DockerDesktop" -Name "Docker Desktop"
Install-App -Id "Kubernetes.kubectl" -Name "kubectl"
Install-App -Id "Helm.Helm" -Name "Helm"

# Terminals & Shells
Install-App -Id "Microsoft.WindowsTerminal" -Name "Windows Terminal"
Install-App -Id "JanDeDobbeleer.OhMyPosh" -Name "Oh My Posh"
Install-App -Id "Microsoft.PowerShell" -Name "PowerShell 7"
Install-App -Id "Mobatek.MobaXterm" -Name "MobaXterm"

# Utilities & System Tools
Install-App -Id "7zip.7zip" -Name "7-Zip"
Install-App -Id "Microsoft.PowerToys" -Name "PowerToys"
Install-App -Id "Notepad++.Notepad++" -Name "Notepad++"
Install-App -Id "Microsoft.EdgeWebView2" -Name "Edge WebView2 Runtime"
Install-App -Id "DominikReichl.KeePass" -Name "KeePass"

# Browsers & Network Tools
Install-App -Id "Google.Chrome" -Name "Google Chrome"
Install-App -Id "Mozilla.Firefox" -Name "Firefox"
Install-App -Id "WiresharkFoundation.Wireshark" -Name "Wireshark"

# Productivity / Media
Install-App -Id "OBSProject.OBSStudio" -Name "OBS Studio"
Install-App -Id "SlackTechnologies.Slack" -Name "Slack"
Install-App -Id "Microsoft.Teams" -Name "Microsoft Teams"
Install-App -Id "GIMP.GIMP" -Name "GIMP"
Install-App -Id "Inkscape.Inkscape" -Name "Inkscape"
Install-App -Id "KDE.Krita" -Name "Krita"
Install-App -Id "BlenderFoundation.Blender" -Name "Blender"
Install-App -Id "Cockos.REAPER" -Name "Reaper"

# Refresh current session's environment variables
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine) + ";" +
            [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User)
Write-Host "Environment variables refreshed."

foreach ($cmd in @("git", "python", "code", "pwsh", "node", "nvm")) {
    if (Get-Command $cmd -ErrorAction SilentlyContinue) {
        Write-Host "$cmd is available in PATH"
    } else {
        Write-Host "$cmd not found in PATH" -ForegroundColor Yellow
    }
}

Write-Host "Tool installation completed." -ForegroundColor Green
