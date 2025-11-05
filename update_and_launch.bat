@echo off
:: ============================================================================
:: PlepperVR Auto-Updater and Launcher
:: ============================================================================
:: This script downloads the latest mrpack from the production repository,
:: updates the Prism Launcher instance while preserving user configurations,
:: and launches the game.
::
:: Configuration can be modified in updater_config.bat
:: ============================================================================

:: Load configuration
if exist "updater_config.bat" (
    call updater_config.bat
) else (
    echo ERROR: Configuration file 'updater_config.bat' not found!
    echo Please ensure the configuration file exists in the same directory.
    pause
    exit /b 1
)

setlocal enabledelayedexpansion

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
echo Repository: %REPO_OWNER%/%REPO_NAME%
echo Instance: %INSTANCE_NAME%
echo.

:: Check if Prism Launcher exists
if not exist "%PRISM_LAUNCHER%" (
    call :printMessage "ERROR: Prism Launcher not found at: %PRISM_LAUNCHER%" "%COLOR_ERROR%"
    call :printMessage "Please check the PRISM_LAUNCHER path in updater_config.bat" "%COLOR_ERROR%"
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
    call :printMessage "Current instance found: %INSTANCE_NAME%" "%COLOR_INFO%"
) else (
    call :printMessage "No existing instance found, will create new one" "%COLOR_WARNING%"
)

:: Get latest release information from GitHub API
call :printMessage "[1/5] Fetching latest release information..." "%COLOR_INFO%"

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

:: Extract filename from URL
for %%f in ("%DOWNLOAD_URL%") do set "MRPACK_NAME=%%~nxf"
call :printMessage "Found mrpack: %MRPACK_NAME%" "%COLOR_SUCCESS%"

:: Download the mrpack file
call :printMessage "[2/5] Downloading mrpack file..." "%COLOR_INFO%"

powershell -Command "& {try { $webClient = New-Object System.Net.WebClient; $webClient.DownloadFile('%DOWNLOAD_URL%', '%TEMP_DIR%\latest.mrpack'); Write-Output 'SUCCESS' } catch { Write-Output 'ERROR' }}" > "%TEMP_DIR%\download_result.txt"

set /p DOWNLOAD_RESULT=<"%TEMP_DIR%\download_result.txt"

if "%DOWNLOAD_RESULT%" neq "SUCCESS" (
    call :printMessage "ERROR: Failed to download mrpack file" "%COLOR_ERROR%"
    goto cleanup
)

call :printMessage "Downloaded successfully" "%COLOR_SUCCESS%"

:: Backup user configurations if enabled
if "%ENABLE_BACKUP%"=="true" (
    call :printMessage "[3/5] Backing up user configurations..." "%COLOR_INFO%"
    set "BACKUP_DIR=%TEMP_DIR%\config_backup"

    if exist "%INSTANCE_DIR%" (
        mkdir "%BACKUP_DIR%" 2>nul

        :: Backup each item in the BACKUP_ITEMS list
        for %%i in (%BACKUP_ITEMS%) do (
            if exist "%INSTANCE_DIR%\minecraft\%%i" (
                if exist "%INSTANCE_DIR%\minecraft\%%i\" (
                    xcopy "%INSTANCE_DIR%\minecraft\%%i" "%BACKUP_DIR%\%%i\" /E /I /Q >nul 2>&1
                ) else (
                    copy "%INSTANCE_DIR%\minecraft\%%i" "%BACKUP_DIR%\" >nul 2>&1
                )
                call :printMessage "  - Backed up %%i" "%COLOR_INFO%"
            )
        )

        call :printMessage "Configuration backup completed" "%COLOR_SUCCESS%"
    ) else (
        call :printMessage "Instance directory not found, will create new instance" "%COLOR_WARNING%"
    )
)

:: Import the mrpack file
call :printMessage "[4/5] Importing mrpack file to Prism Launcher..." "%COLOR_INFO%"

start "" /wait "%PRISM_LAUNCHER%" -d "%PRISM_DATA_DIR%" -I "%TEMP_DIR%\latest.mrpack"

if errorlevel 1 (
    call :printMessage "ERROR: Failed to import mrpack file" "%COLOR_ERROR%"
    goto cleanup
)

call :printMessage "Mrpack imported successfully" "%COLOR_SUCCESS%"

:: Restore user configurations if backup was created
if "%ENABLE_BACKUP%"=="true" if exist "%BACKUP_DIR%" (
    call :printMessage "[5/5] Restoring user configurations..." "%COLOR_INFO%"

    :: Restore each item in the BACKUP_ITEMS list
    for %%i in (%BACKUP_ITEMS%) do (
        if exist "%BACKUP_DIR%\%%i" (
            if exist "%BACKUP_DIR%\%%i\" (
                xcopy "%BACKUP_DIR%\%%i" "%INSTANCE_DIR%\minecraft\%%i\" /E /I /Q >nul 2>&1
            ) else (
                copy "%BACKUP_DIR%\%%i" "%INSTANCE_DIR%\minecraft\" >nul 2>&1
            )
            call :printMessage "  - Restored %%i" "%COLOR_INFO%"
        )
    )

    call :printMessage "User configurations restored" "%COLOR_SUCCESS%"
)

:: Launch the game
if "%LAUNCH_AFTER_UPDATE%"=="true" (
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
echo Press any key to exit...
pause >nul
color %COLOR_INFO%
endlocal
goto :eof