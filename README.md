# 🛠️ Dev Environment Bootstrapper

This repository provides a fully automated, modular, and extensible system to configure and provision new development machines — starting with **Windows**, with planned support for **Linux** and **WSL**.

## 📦 Features

- 🔧 System-level configuration (registry, explorer, privacy, appearance)
- 📥 Automatic installation of development tools via `winget`
- 💻 Full-stack dev environment setup (CLI, IDEs, SDKs, cloud tools, containers)
- 🧹 Bloatware removal and basic hardening
- 💡 Modular, readable, and version-controlled scripts
- 🧪 Admin checks, logging, and error handling
- 🌐 Cross-platform layout ready: Windows, WSL, Linux

---

## 🗂️ Structure


---

## ✅ Requirements

- Windows 10 or 11
- PowerShell 7+ (recommended)
- Administrator privileges (required)

---

## 🚀 Usage (Windows)

```powershell
Start-Process powershell -Verb RunAs
cd path\to\repo\windows
./run.ps1
```

The script will:

1. Apply system-level tweaks
2. Install packages with winget
3. Configure tools and shells
4. Install development environments and utilities

## 🪄 Coming Soon

- linux/: Bash/Zsh-based setup scripts (Debian/Ubuntu focus)
- wsl/: Provisioning of WSL distros, dotfiles, and interoperability
- JSON/YAML-based config files for tool selection
- Cross-platform environment sync (fonts, aliases, themes)

## 📁 Customization

You can customize what gets installed or configured by editing:

- 10-winget.ps1: Add/remove tools to install
- 20-config.ps1: Set up shell, Git, terminal profiles, etc.

## 🧪 Notes

All scripts are idempotent: running them again won’t reinstall existing tools
Logging and output are written to the console (log file support optional)
Designed to be run on fresh installs or new developer machines

## 🧠 Contributions

Contributions and suggestions are welcome! Feel free to fork and PR improvements, especially for:

- Linux and WSL support
- Additional setup profiles (game dev, data science, etc.)
- Install-time config UI (TUI or GUI wrappers)

## 📜 License

MIT License

```git
Built by developers, for developers. Automate your machine, focus on your code.
```
