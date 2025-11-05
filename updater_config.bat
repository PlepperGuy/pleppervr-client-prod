@echo off
:: ============================================================================
:: PlepperVR Updater Configuration
:: ============================================================================
:: Edit these variables to customize the updater behavior
:: ============================================================================

:: GitHub Repository Information
set "REPO_OWNER=PlepperGuy"
set "REPO_NAME=pleppervr-client-production"

:: Prism Launcher Settings
set "INSTANCE_NAME=PlepperVR_Test"
set "PRISM_LAUNCHER=C:\Users\white\AppData\Local\Programs\PrismLauncher\prismlauncher.exe"
set "PRISM_DATA_DIR=C:\Users\white\AppData\Roaming\PrismLauncher"

:: Update Behavior
set "ENABLE_BACKUP=true"          :: Set to "false" to disable config backup
set "LAUNCH_AFTER_UPDATE=true"    :: Set to "false" to skip auto-launch
set "SKIP_UPDATE_IF_CURRENT=true" :: Set to "false" to force update check

:: Advanced Settings (usually no need to change)
set "TEMP_DIR=%TEMP%\PlepperVR_Update"
set "LOG_FILE=%TEMP_DIR%\update_log.txt"

:: Backup Items (comma-separated list)
set "BACKUP_ITEMS=options.txt,config,saves,resourcepacks,shaderpacks,screenshots,instance.cfg"