Write-Host "🛠 Setting up devtoolchain..." -ForegroundColor Cyan

# --- pipx tools ---
Write-Host "→ Installing Python CLI tools via pipx..."
if (-not (Get-Command pipx -ErrorAction SilentlyContinue)) {
    python -m pip install --user pipx
    python -m pipx ensurepath

    $pythonUserBase = python -c "import site; print(site.USER_BASE)"
    $pythonScriptsPath = Join-Path $pythonUserBase 'Scripts'
    if (-not ($env:Path -like "*$pythonScriptsPath*")) {
        $env:Path += ";$pythonScriptsPath"
        Write-Host "✔ Added pipx to PATH"
    }
}

function Ensure-PipxTool {
    param([string]$ToolName)
    if (-not (pipx list | Select-String $ToolName)) {
        Write-Host "→ Installing $ToolName via pipx..."
        try {
            pipx install $ToolName
            Write-Host "✔ Installed $ToolName"
        } catch {
            Write-Host "⚠️ Failed to install $ToolName: $_" -ForegroundColor Yellow
        }
    } else {
        Write-Host "✔ $ToolName already installed"
    }
}

Ensure-PipxTool "black"
Ensure-PipxTool "ruff"
Ensure-PipxTool "poetry"
Ensure-PipxTool "jupyterlab"
Ensure-PipxTool "ipython"

# --- Node.js / NVM ---
Write-Host "→ Setting up Node.js via NVM..."
$nvmPath = "$env:LOCALAPPDATA\nvm"
if (Test-Path $nvmPath -and (Get-Command nvm -ErrorAction SilentlyContinue)) {
    nvm install lts
    nvm use lts
    npm install -g pnpm eslint prettier typescript
} else {
    Write-Host "⚠️ NVM not found, skipping Node setup." -ForegroundColor Yellow
}
Write-Host "→ Installing global Node.js CLI tools..."

npm install -g nodemon typescript vite expo-cli


# --- Rust ---
Write-Host "→ Setting up Rust CLI tools..."
$env:CARGO_HOME = "$env:USERPROFILE\.cargo"
$env:PATH += ";$env:CARGO_HOME\bin"
$rustTools = @("ripgrep", "fd-find", "bat", "lsd")
foreach ($tool in $rustTools) {
    if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) {
        Write-Host "→ Installing $tool via cargo..."
        try {
            cargo install $tool
            Write-Host "✔ Installed $tool"
        } catch {
            Write-Host "⚠️ Failed to install $tool: $_" -ForegroundColor Yellow
        }
    } else {
        Write-Host "✔ $tool already installed"
    }
}

Write-Host "→ Installing Composer (PHP package manager)..."

$composerSetupUrl = "https://getcomposer.org/installer"
$composerPhar = "$env:TEMP\composer-setup.php"
$composerExePath = "$env:LOCALAPPDATA\Composer\composer.phar"
$composerBinPath = "$env:LOCALAPPDATA\Composer"

if (-not (Test-Path $composerBinPath)) {
    New-Item -ItemType Directory -Path $composerBinPath -Force | Out-Null
}

Invoke-WebRequest -Uri $composerSetupUrl -OutFile $composerPhar

Write-Host "→ Running Composer installer..."
php $composerPhar --install-dir=$composerBinPath --filename=composer.phar

Remove-Item $composerPhar

# Add composer to PATH if not present
if (-not ($env:Path -like "*$composerBinPath*")) {
    Write-Host "→ Adding Composer directory to PATH..."
    [Environment]::SetEnvironmentVariable("Path", $env:Path + ";$composerBinPath", [EnvironmentVariableTarget]::User)
    $env:Path += ";$composerBinPath"
} else {
    Write-Host "✔ Composer directory already in PATH"
}

Write-Host "✔ Composer installed."


# --- Go tools ---
Write-Host "→ Installing Go CLI tools..."
$goBin = "$env:USERPROFILE\go\bin"
if (-not ($env:Path -like "*$goBin*")) {
    $env:Path += ";$goBin"
}
go install golang.org/x/tools/cmd/goimports@latest
go install github.com/ramya-rao-a/go-outline@latest

# --- GitHub CLI auth (optional) ---
Write-Host "→ Authenticating GitHub CLI..."
gh auth status
# gh auth login --web --hostname github.com

# --- Dotnet tools ---
Write-Host "→ Installing global .NET tools..."
if (-not (dotnet tool list -g | Select-String "dotnet-ef")) {
    dotnet tool install --global dotnet-ef
} else {
    Write-Host "✔ dotnet-ef already installed"
}

# --- Flutter SDK Manual Install ---
Write-Host "→ Installing Flutter SDK manually..."

$flutterZipUrl = "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.13.5-stable.zip"
$installPath = "$env:LOCALAPPDATA\flutter"
$zipFile = "$env:TEMP\flutter_sdk.zip"

if (-not (Test-Path $installPath)) {
    Invoke-WebRequest -Uri $flutterZipUrl -OutFile $zipFile
    Expand-Archive -Path $zipFile -DestinationPath $env:LOCALAPPDATA -Force
    Remove-Item $zipFile
    Write-Host "✔ Flutter SDK extracted to $installPath"
} else {
    Write-Host "✔ Flutter SDK already installed at $installPath"
}

# Add Flutter to PATH if not present
$flutterBinPath = "$installPath\flutter\bin"
if (-not ($env:Path -like "*$flutterBinPath*")) {
    Write-Host "→ Adding Flutter to PATH..."
    [Environment]::SetEnvironmentVariable("Path", $env:Path + ";$flutterBinPath", [EnvironmentVariableTarget]::User)
    $env:Path += ";$flutterBinPath"
} else {
    Write-Host "✔ Flutter already in PATH"
}

# Run flutter doctor
Write-Host "→ Running flutter doctor..."
flutter doctor

# TODO: ODBC

# --- Docker / Kubernetes Tools ---
Write-Host "→ Configuring Docker & K8s CLI..."
if (Get-Command kubectl -ErrorAction SilentlyContinue) {
    kubectl version --client
} else {
    Write-Host "⚠️ kubectl not found, skipping Kubernetes CLI check." -ForegroundColor Yellow
}


# --- AI / LLM Tools ---
Write-Host "→ Setting up Ollama (local LLM in Docker)..."
if (Get-Command docker -ErrorAction SilentlyContinue) {
    try {
        docker pull ollama/ollama:latest
        Write-Host "✔ Pulled Ollama Docker image."
        
        $containerRunning = docker ps --filter "name=ollama" --quiet
        if (-not $containerRunning) {
            docker run -d --name ollama -p 11434:11434 ollama/ollama:latest
            Write-Host "✔ Ollama container started."
        } else {
            Write-Host "✔ Ollama container already running."
        }
    } catch {
        Write-Host "⚠️ Error during Ollama setup: $_" -ForegroundColor Yellow
    }
} else {
    Write-Host "⚠️ Docker is not installed or not in PATH, skipping Ollama setup." -ForegroundColor Yellow
}



Write-Host "✅ Devtool setup completed." -ForegroundColor Green
