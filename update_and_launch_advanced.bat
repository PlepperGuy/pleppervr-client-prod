@echo off
setlocal enabledelayedexpansion

:: ============================================================================
:: PlepperVR Auto-Updater and Launcher
:: ============================================================================
:: This script downloads the latest mrpack from the production repository,
:: updates the Prism Launcher instance while preserving user configurations,
:: and launches the game.
:: ============================================================================

:: Configuration - Edit these variables as needed
set "REPO_OWNER=PlepperGuy"
set "REPO_NAME=pleppervr-client-production"
set "INSTANCE_NAME=PlepperVR_Test"
set "PRISM_LAUNCHER=C:\Users\white\AppData\Local\Programs\PrismLauncher\prismlauncher.exe"
set "PRISM_DATA_DIR=C:\Users\white\AppData\Roaming\PrismLauncher"
set "TEMP_DIR=%TEMP%\PlepperVR_Update"
set "LOG_FILE=%TEMP_DIR%\update_log.txt"
set "ENABLE_BACKUP=true"
set "LAUNCH_AFTER_UPDATE=true"
set "SKIP_UPDATE_IF_CURRENT=true"

:: Colors for output
set "COLOR_INFO=07"
set "COLOR_SUCCESS=0A"
set "COLOR_WARNING=0E"
set "COLOR_ERROR=0C"

:: Initialize log
mkdir "%TEMP_DIR%" 2>nul
echo PlepperVR Update Log - %date% %time% > "%LOG_FILE%"
echo ======================================== >> "%LOG_FILE%"

:: Function to display colored messages
:printMessage
set "message=%~1"
set "color=%~2"
if "%color%"=="" set "color=%COLOR_INFO%"
color %color%
echo %message%
color %COLOR_INFO%
echo %message% >> "%LOG_FILE%"
goto :eof

:: Main execution starts here
color %COLOR_INFO%
echo ========================================
echo PlepperVR Auto-Updater and Launcher
echo ========================================
echo.

:: Check if Prism Launcher exists
if not exist "%PRISM_LAUNCHER%" (
    call :printMessage "ERROR: Prism Launcher not found at: %PRISM_LAUNCHER%" "%COLOR_ERROR%"
    goto cleanup
)

call :printMessage "Prism Launcher found: %PRISM_LAUNCHER%" "%COLOR_SUCCESS%"

:: Create temporary directory
if exist "%TEMP_DIR%" rmdir /s /q "%TEMP_DIR%" 2>nul
mkdir "%TEMP_DIR%"

:: Get current version information if instance exists
set "CURRENT_VERSION="
set "INSTANCE_DIR=%PRISM_DATA_DIR%\instances\%INSTANCE_NAME%"
if exist "%INSTANCE_DIR%\instance.cfg" (
    for /f "tokens=2 delims==" %%a in ('findstr /i "name" "%INSTANCE_DIR%\instance.cfg" 2^>nul') do set "CURRENT_VERSION=%%a"
    call :printMessage "Current instance found: %INSTANCE_NAME%" "%COLOR_INFO%"
) else (
    call :printMessage "No existing instance found, will create new one" "%COLOR_WARNING%"
)

:: Get latest release information from GitHub API
call :printMessage "[1/6] Fetching latest release information..." "%COLOR_INFO%"

powershell -Command "& {try { $release = Invoke-RestMethod -Uri 'https://api.github.com/repos/%REPO_OWNER%/%REPO_NAME%/releases/latest' -Headers @{'User-Agent'='PlepperVR-Updater'}; $asset = $release.assets | Where-Object { $_.name -like '*.mrpack' } | Select-Object -First 1; if ($asset) { Write-Output $asset.browser_download_url } else { Write-Output 'NO_MRPACK' } } catch { Write-Output 'ERROR' }}" > "%TEMP_DIR%\download_url.txt"

if errorlevel 1 (
    call :printMessage "ERROR: Failed to fetch release information from GitHub" "%COLOR_ERROR%"
    goto cleanup
)

set /p DOWNLOAD_URL=<"%TEMP_DIR%\download_url.txt"

if "%DOWNLOAD_URL%"=="ERROR" (
    call :printMessage "ERROR: GitHub API request failed" "%COLOR_ERROR%"
    goto cleanup
)

if "%DOWNLOAD_URL%"=="NO_MRPACK" (
    call :printMessage "ERROR: No mrpack file found in latest release" "%COLOR_ERROR%"
    goto cleanup
)

:: Extract version from URL or filename
for %%f in ("%DOWNLOAD_URL%") do set "MRPACK_NAME=%%~nxf"
call :printMessage "Found mrpack: %MRPACK_NAME%" "%COLOR_SUCCESS%"
call :printMessage "Download URL: %DOWNLOAD_URL%" "%COLOR_INFO%"

:: Check if we should skip update
if "%SKIP_UPDATE_IF_CURRENT%"=="true" if "%CURRENT_VERSION%" neq "" (
    if "%MRPACK_NAME%"=="%CURRENT_VERSION%-mrpack" (
        call :printMessage "Already on latest version, skipping update" "%COLOR_SUCCESS%"
        goto launch_game
    )
)

:: Download the mrpack file
call :printMessage "[2/6] Downloading mrpack file..." "%COLOR_INFO%"

powershell -Command "& {try { $webClient = New-Object System.Net.WebClient; $webClient.DownloadFile('%DOWNLOAD_URL%', '%TEMP_DIR%\latest.mrpack'); Write-Output 'SUCCESS' } catch { Write-Output 'ERROR' }}" > "%TEMP_DIR%\download_result.txt"

set /p DOWNLOAD_RESULT=<"%TEMP_DIR%\download_result.txt"

if "%DOWNLOAD_RESULT%" neq "SUCCESS" (
    call :printMessage "ERROR: Failed to download mrpack file" "%COLOR_ERROR%"
    goto cleanup
)

call :printMessage "Downloaded successfully to %TEMP_DIR%\latest.mrpack" "%COLOR_SUCCESS%"

:: Backup user configurations if enabled
if "%ENABLE_BACKUP%"=="true" (
    call :printMessage "[3/6] Backing up user configurations..." "%COLOR_INFO%"
    set "BACKUP_DIR=%TEMP_DIR%\config_backup"

    if exist "%INSTANCE_DIR%" (
        mkdir "%BACKUP_DIR%" 2>nul

        :: Backup important config files and directories
        if exist "%INSTANCE_DIR%\minecraft\options.txt" (
            copy "%INSTANCE_DIR%\minecraft\options.txt" "%BACKUP_DIR%\" >nul 2>&1
            call :printMessage "  - Backed up options.txt" "%COLOR_INFO%"
        )

        if exist "%INSTANCE_DIR%\minecraft\config" (
            xcopy "%INSTANCE_DIR%\minecraft\config" "%BACKUP_DIR%\config\" /E /I /Q >nul 2>&1
            call :printMessage "  - Backed up config directory" "%COLOR_INFO%"
        )

        if exist "%INSTANCE_DIR%\minecraft\saves" (
            xcopy "%INSTANCE_DIR%\minecraft\saves" "%BACKUP_DIR%\saves\" /E /I /Q >nul 2>&1
            call :printMessage "  - Backed up saves directory" "%COLOR_INFO%"
        )

        if exist "%INSTANCE_DIR%\minecraft\resourcepacks" (
            xcopy "%INSTANCE_DIR%\minecraft\resourcepacks" "%BACKUP_DIR%\resourcepacks\" /E /I /Q >nul 2>&1
            call :printMessage "  - Backed up resourcepacks directory" "%COLOR_INFO%"
        )

        if exist "%INSTANCE_DIR%\minecraft\shaderpacks" (
            xcopy "%INSTANCE_DIR%\minecraft\shaderpacks" "%BACKUP_DIR%\shaderpacks\" /E /I /Q >nul 2>&1
            call :printMessage "  - Backed up shaderpacks directory" "%COLOR_INFO%"
        )

        if exist "%INSTANCE_DIR%\minecraft\screenshots" (
            xcopy "%INSTANCE_DIR%\minecraft\screenshots" "%BACKUP_DIR%\screenshots\" /E /I /Q >nul 2>&1
            call :printMessage "  - Backed up screenshots directory" "%COLOR_INFO%"
        )

        if exist "%INSTANCE_DIR%\instance.cfg" (
            copy "%INSTANCE_DIR%\instance.cfg" "%BACKUP_DIR%\" >nul 2>&1
            call :printMessage "  - Backed up instance configuration" "%COLOR_INFO%"
        )

        call :printMessage "Configuration backup completed" "%COLOR_SUCCESS%"
    ) else (
        call :printMessage "Instance directory not found, will create new instance" "%COLOR_WARNING%"
    )
)

:: Import the mrpack file
call :printMessage "[4/6] Importing mrpack file to Prism Launcher..." "%COLOR_INFO%"

start "" /wait "%PRISM_LAUNCHER%" -d "%PRISM_DATA_DIR%" -I "%TEMP_DIR%\latest.mrpack"

if errorlevel 1 (
    call :printMessage "ERROR: Failed to import mrpack file" "%COLOR_ERROR%"
    goto cleanup
)

call :printMessage "Mrpack imported successfully" "%COLOR_SUCCESS%"

:: Restore user configurations if backup was created
if "%ENABLE_BACKUP%"=="true" if exist "%BACKUP_DIR%" (
    call :printMessage "[5/6] Restoring user configurations..." "%COLOR_INFO%"

    :: Restore config files and directories
    if exist "%BACKUP_DIR%\options.txt" (
        copy "%BACKUP_DIR%\options.txt" "%INSTANCE_DIR%\minecraft\" >nul 2>&1
        call :printMessage "  - Restored options.txt" "%COLOR_INFO%"
    )

    if exist "%BACKUP_DIR%\config" (
        xcopy "%BACKUP_DIR%\config" "%INSTANCE_DIR%\minecraft\config\" /E /I /Q >nul 2>&1
        call :printMessage "  - Restored config directory" "%COLOR_INFO%"
    )

    if exist "%BACKUP_DIR%\saves" (
        xcopy "%BACKUP_DIR%\saves" "%INSTANCE_DIR%\minecraft\saves\" /E /I /Q >nul 2>&1
        call :printMessage "  - Restored saves directory" "%COLOR_INFO%"
    )

    if exist "%BACKUP_DIR%\resourcepacks" (
        xcopy "%BACKUP_DIR%\resourcepacks" "%INSTANCE_DIR%\minecraft\resourcepacks\" /E /I /Q >nul 2>&1
        call :printMessage "  - Restored resourcepacks directory" "%COLOR_INFO%"
    )

    if exist "%BACKUP_DIR%\shaderpacks" (
        xcopy "%BACKUP_DIR%\shaderpacks" "%INSTANCE_DIR%\minecraft\shaderpacks\" /E /I /Q >nul 2>&1
        call :printMessage "  - Restored shaderpacks directory" "%COLOR_INFO%"
    )

    if exist "%BACKUP_DIR%\screenshots" (
        xcopy "%BACKUP_DIR%\screenshots" "%INSTANCE_DIR%\minecraft\screenshots\" /E /I /Q >nul 2>&1
        call :printMessage "  - Restored screenshots directory" "%COLOR_INFO%"
    )

    call :printMessage "User configurations restored" "%COLOR_SUCCESS%"
)

:launch_game
if "%LAUNCH_AFTER_UPDATE%"=="true" (
    call :printMessage "[6/6] Launching PlepperVR..." "%COLOR_INFO%"
    echo.
    echo ========================================
    echo Launching PlepperVR...
    echo ========================================
    echo.
    call :printMessage "Starting Prism Launcher with instance: %INSTANCE_NAME%" "%COLOR_INFO%"
    echo.

    start "" "%PRISM_LAUNCHER%" -d "%PRISM_DATA_DIR%" -l "%INSTANCE_NAME%"

    if errorlevel 1 (
        call :printMessage "WARNING: Failed to launch game automatically" "%COLOR_WARNING%"
        call :printMessage "Please launch the game manually from Prism Launcher" "%COLOR_WARNING%"
    ) else (
        call :printMessage "Game launched successfully!" "%COLOR_SUCCESS%"
    )
) else (
    call :printMessage "Update completed. Auto-launch is disabled." "%COLOR_INFO%"
)

:cleanup
:: Clean up temporary files
call :printMessage "Cleaning up temporary files..." "%COLOR_INFO%"
if exist "%TEMP_DIR%" rmdir /s /q "%TEMP_DIR%" 2>nul

echo.
call :printMessage "Update process completed!" "%COLOR_SUCCESS%"
echo.
call :printMessage "Log file saved to: %LOG_FILE%" "%COLOR_INFO%"
echo.
echo Press any key to exit...
pause >nul
color %COLOR_INFO%
endlocal
goto :eof