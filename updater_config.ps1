# ============================================================================
# PlepperVR Updater Configuration (PowerShell)
# ============================================================================
# Edit these variables to customize the updater behavior
# ============================================================================

# GitHub Repository Information
$Config.RepoOwner = "PlepperGuy"
$Config.RepoName = "pleppervr-client-production"

# Prism Launcher Settings
$Config.InstanceName = "PlepperVR_Test"
$Config.PrismLauncherPath = "$env:LOCALAPPDATA\Programs\PrismLauncher\prismlauncher.exe"
$Config.PrismDataDir = "$env:APPDATA\PrismLauncher"

# Update Behavior
$Config.EnableBackup = $true          # Set to $false to disable config backup
$Config.LaunchAfterUpdate = $true     # Set to $false to skip auto-launch
$Config.SkipUpdateIfCurrent = $false  # Set to $false to force update check

# Backup Items (array of items to backup/restore)
$Config.BackupItems = @(
    "options.txt",      # Game settings and controls
    "config",           # Mod configuration files
    "saves",            # World saves
    "resourcepacks",    # Custom resource packs
    "shaderpacks",      # Custom shader packs
    "screenshots",      # In-game screenshots
    "instance.cfg"      # Instance configuration
)