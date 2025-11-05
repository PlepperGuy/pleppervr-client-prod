# ============================================================================
# PlepperVR Auto-Updater and Launcher (PowerShell Version)
# ============================================================================
# This script downloads the latest mrpack from the production repository,
# updates the Prism Launcher instance while preserving user configurations,
# and launches the game.
#
# Configuration can be modified below or in the external config file.
# ============================================================================

# Add required assemblies for Windows Forms
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Configuration
$Config = @{
    # GitHub Repository Information
    RepoOwner = "PlepperGuy"
    RepoName = "pleppervr-client-production"

    # Prism Launcher Settings
    InstanceName = "PlepperVR_Test"
    PrismLauncherPath = "$env:LOCALAPPDATA\Programs\PrismLauncher\prismlauncher.exe"
    PrismDataDir = "$env:APPDATA\PrismLauncher"

    # Update Behavior
    EnableBackup = $true
    LaunchAfterUpdate = $true
    SkipUpdateIfCurrent = $false

    # Advanced Settings
    TempDir = "$env:TEMP\PlepperVR_Update"
    LogFile = "$env:TEMP\PlepperVR_Update\update_log.txt"

    # Backup Items
    BackupItems = @("options.txt", "config", "saves", "resourcepacks", "shaderpacks", "screenshots", "instance.cfg")
}

# Function to load external configuration if exists
function Load-ExternalConfig {
    $configPath = Join-Path $PSScriptRoot "updater_config.ps1"
    if (Test-Path $configPath) {
        try {
            . $configPath
            Write-Log "Loaded external configuration from $configPath"
        } catch {
            Write-Log "Warning: Failed to load external configuration: $_" -Warning
        }
    }
}

# Function to write log messages
function Write-Log {
    param(
        [string]$Message,
        [string]$Level = "INFO",
        [switch]$NoNewline
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"

    # Write to console with colors
    switch ($Level) {
        "ERROR" { Write-Host $Message -ForegroundColor Red }
        "WARNING" { Write-Host $Message -ForegroundColor Yellow }
        "SUCCESS" { Write-Host $Message -ForegroundColor Green }
        default { Write-Host $Message -ForegroundColor White }
    }

    # Write to log file
    try {
        if (!(Test-Path (Split-Path $Config.LogFile))) {
            New-Item -ItemType Directory -Path (Split-Path $Config.LogFile) -Force | Out-Null
        }
        if ($NoNewline) {
            Add-Content -Path $Config.LogFile -Value $logMessage -NoNewline
        } else {
            Add-Content -Path $Config.LogFile -Value $logMessage
        }
    } catch {
        # Ignore log file errors
    }
}

# Function to show progress bar
function Show-Progress {
    param(
        [string]$Activity,
        [string]$Status,
        [int]$PercentComplete = -1
    )

    if ($PercentComplete -ge 0) {
        Write-Progress -Activity $Activity -Status $Status -PercentComplete $PercentComplete
    } else {
        Write-Progress -Activity $Activity -Status $Status
    }
}

# Function to download file with progress
function Download-FileWithProgress {
    param(
        [string]$Url,
        [string]$OutputPath
    )

    try {
        $webClient = New-Object System.Net.WebClient
        $webClient.DownloadFileCompleted += {
            param($sender, $e)
            if ($e.Cancelled) {
                Write-Log "Download cancelled" -Warning
            } elseif ($e.Error) {
                Write-Log "Download failed: $($e.Error.Message)" -Error
            }
        }

        $webClient.DownloadProgressChanged += {
            param($sender, $e)
            $percent = $e.BytesReceived * 100 / $e.TotalBytesToReceive
            Show-Progress "Downloading" "$([math]::Round($percent))% complete" $percent
        }

        Show-Progress "Downloading" "Starting download..."
        $webClient.DownloadFileAsync($Url, $OutputPath)

        # Wait for download to complete
        while ($webClient.IsBusy) {
            Start-Sleep -Milliseconds 100
        }

        Write-Progress -Activity "Downloading" -Completed
        return $true
    } catch {
        Write-Log "Download failed: $_" -Error
        return $false
    } finally {
        if ($webClient) {
            $webClient.Dispose()
        }
    }
}

# Function to backup and restore directories/files
function Backup-Item {
    param(
        [string]$Source,
        [string]$Destination,
        [string]$ItemName
    )

    try {
        if (Test-Path $Source) {
            $destPath = Join-Path $Destination $ItemName

            if ((Get-Item $Source) -is [System.IO.DirectoryInfo]) {
                Copy-Item -Path $Source -Destination $destPath -Recurse -Force
            } else {
                Copy-Item -Path $Source -Destination $destPath -Force
            }

            Write-Log "  - Backed up $ItemName"
            return $true
        }
    } catch {
        Write-Log "  - Failed to backup $ItemName`: $_" -Warning
    }
    return $false
}

function Restore-Item {
    param(
        [string]$Source,
        [string]$Destination,
        [string]$ItemName
    )

    try {
        $sourcePath = Join-Path $Source $ItemName
        $destPath = Join-Path $Destination $ItemName

        if (Test-Path $sourcePath) {
            if ((Get-Item $sourcePath) -is [System.IO.DirectoryInfo]) {
                Copy-Item -Path $sourcePath -Destination $destPath -Recurse -Force
            } else {
                Copy-Item -Path $sourcePath -Destination $destPath -Force
            }

            Write-Log "  - Restored $ItemName"
            return $true
        }
    } catch {
        Write-Log "  - Failed to restore $ItemName`: $_" -Warning
    }
    return $false
}

# Main update function
function Start-PlepperVRUpdate {
    try {
        Write-Log "========================================"
        Write-Log "PlepperVR Auto-Updater and Launcher"
        Write-Log "========================================"
        Write-Log "Repository: $($Config.RepoOwner)/$($Config.RepoName)"
        Write-Log "Instance: $($Config.InstanceName)"
        Write-Log ""

        # Check if Prism Launcher exists
        if (!(Test-Path $Config.PrismLauncherPath)) {
            Write-Log "ERROR: Prism Launcher not found at: $($Config.PrismLauncherPath)" -Error
            Write-Log "Please check the PrismLauncherPath in configuration" -Error
            return $false
        }

        Write-Log "Prism Launcher found: $($Config.PrismLauncherPath)" -Success

        # Create temporary directory
        if (Test-Path $Config.TempDir) {
            Remove-Item -Path $Config.TempDir -Recurse -Force
        }
        New-Item -ItemType Directory -Path $Config.TempDir -Force | Out-Null

        # Check current instance
        $instanceDir = Join-Path $Config.PrismDataDir "instances" $Config.InstanceName
        $currentVersion = $null

        if (Test-Path $instanceDir) {
            Write-Log "Current instance found: $($Config.InstanceName)"
        } else {
            Write-Log "No existing instance found, will create new one" -Warning
        }

        # Get latest release information
        Write-Log "[1/5] Fetching latest release information..."
        $apiUrl = "https://api.github.com/repos/$($Config.RepoOwner)/$($Config.RepoName)/releases/latest"

        try {
            $release = Invoke-RestMethod -Uri $apiUrl -Headers @{
                "User-Agent" = "PlepperVR-Updater"
            }

            $mrpackAsset = $release.assets | Where-Object { $_.name -like "*.mrpack" } | Select-Object -First 1

            if (!$mrpackAsset) {
                Write-Log "ERROR: No mrpack file found in latest release" -Error
                return $false
            }

            $downloadUrl = $mrpackAsset.browser_download_url
            $mrpackName = $mrpackAsset.name

            Write-Log "Found mrpack: $mrpackName" -Success
        } catch {
            Write-Log "ERROR: Failed to fetch release information: $_" -Error
            return $false
        }

        # Download the mrpack file
        Write-Log "[2/5] Downloading mrpack file..."
        $mrpackPath = Join-Path $Config.TempDir "latest.mrpack"

        if (!(Download-FileWithProgress -Url $downloadUrl -OutputPath $mrpackPath)) {
            Write-Log "ERROR: Failed to download mrpack file" -Error
            return $false
        }

        Write-Log "Downloaded successfully" -Success

        # Backup user configurations
        if ($Config.EnableBackup) {
            Write-Log "[3/5] Backing up user configurations..."
            $backupDir = Join-Path $Config.TempDir "config_backup"

            if (Test-Path $instanceDir) {
                New-Item -ItemType Directory -Path $backupDir -Force | Out-Null

                foreach ($item in $Config.BackupItems) {
                    $sourcePath = Join-Path $instanceDir "minecraft" $item
                    Backup-Item -Source $sourcePath -Destination $backupDir -ItemName $item
                }

                Write-Log "Configuration backup completed" -Success
            } else {
                Write-Log "Instance directory not found, will create new instance" -Warning
            }
        }

        # Import the mrpack file
        Write-Log "[4/5] Importing mrpack file to Prism Launcher..."

        $process = Start-Process -FilePath $Config.PrismLauncherPath -ArgumentList @(
            "-d", $Config.PrismDataDir,
            "-I", $mrpackPath
        ) -Wait -PassThru

        if ($process.ExitCode -ne 0) {
            Write-Log "WARNING: Import process may have failed (exit code: $($process.ExitCode))" -Warning
        } else {
            Write-Log "Mrpack imported successfully" -Success
        }

        # Restore user configurations
        if ($Config.EnableBackup -and (Test-Path $backupDir)) {
            Write-Log "[5/5] Restoring user configurations..."

            foreach ($item in $Config.BackupItems) {
                Restore-Item -Source $backupDir -Destination (Join-Path $instanceDir "minecraft") -ItemName $item
            }

            Write-Log "User configurations restored" -Success
        }

        # Launch the game
        if ($Config.LaunchAfterUpdate) {
            Write-Log ""
            Write-Log "========================================"
            Write-Log "Launching PlepperVR..."
            Write-Log "========================================"
            Write-Log ""
            Write-Log "Starting Prism Launcher with instance: $($Config.InstanceName)"
            Write-Log ""

            try {
                Start-Process -FilePath $Config.PrismLauncherPath -ArgumentList @(
                    "-d", $Config.PrismDataDir,
                    "-l", $Config.InstanceName
                )

                Write-Log "Game launched successfully!" -Success
            } catch {
                Write-Log "WARNING: Failed to launch game automatically: $_" -Warning
                Write-Log "Please launch the game manually from Prism Launcher" -Warning
            }
        } else {
            Write-Log "Update completed. Auto-launch is disabled."
        }

        return $true

    } catch {
        Write-Log "Unexpected error: $_" -Error
        return $false
    }
}

# Cleanup function
function Start-Cleanup {
    Write-Log "Cleaning up temporary files..."

    try {
        if (Test-Path $Config.TempDir) {
            Remove-Item -Path $Config.TempDir -Recurse -Force
        }
    } catch {
        Write-Log "Failed to clean up temporary files: $_" -Warning
    }
}

# Main execution
try {
    # Load external configuration
    Load-ExternalConfig

    # Initialize log
    if (!(Test-Path (Split-Path $Config.LogFile))) {
        New-Item -ItemType Directory -Path (Split-Path $Config.LogFile) -Force | Out-Null
    }

    "PlepperVR Update Log - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" | Out-File -FilePath $Config.LogFile
    "========================================" | Out-File -FilePath $Config.LogFile -Append

    # Run the update
    $success = Start-PlepperVRUpdate

    if ($success) {
        Write-Log ""
        Write-Log "Update process completed!" -Success
    } else {
        Write-Log ""
        Write-Log "Update process failed!" -Error
    }

    Write-Log ""
    Write-Log "Log file: $($Config.LogFile)"
    Write-Log ""
    Write-Log "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

} catch {
    Write-Log "Fatal error: $_" -Error
    Write-Log "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
} finally {
    Start-Cleanup
}