@echo off
setlocal enabledelayedexpansion

:: Enhanced PlepperVR Modpack Updater with better UX for friends
:: Version 2.0 - User-friendly improvements

:: Set console colors for better readability
color 0A

:: Configuration
set GITHUB_REPO=https://github.com/PlepperGuy/PlepperVR
set VERSION_FILE=version_info.txt
set UPDATE_LOG=update_log.txt

:: ========================================
:: 🎮 PLEPPERVR MODPACK UPDATER v2.0
:: ========================================
echo.
echo  ████████╗ █████╗ ███╗   ██╗██╗  ██╗    ██████╗ ██╗   ██╗███████╗██████╗
echo  ╚══██╔══╝██╔══██╗████╗  ██║██║ ██╔╝    ██╔══██╗██║   ██║██╔════╝██╔══██╗
echo     ██║   ███████║██╔██╗ ██║█████╔╝     ██████╔╝██║   ██║█████╗  ██████╔╝
echo     ██║   ██╔══██║██║╚██╗██║██╔═██╗     ██╔══██╗██║   ██║██╔══╝  ██╔══██╗
echo     ██║   ██║  ██║██║ ╚████║██║  ██╗    ██████╔╝╚██████╔╝███████╗██║  ██║
echo     ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝╚═╝  ╚═╝
echo.
echo  ========================================
echo     PlepperVR Modpack Auto-Updater
echo  ========================================
echo.

:: Check for version info file
set CURRENT_VERSION=Unknown
if exist "%VERSION_FILE%" (
    for /f "tokens=*" %%i in ('type "%VERSION_FILE%"') do set CURRENT_VERSION=%%i
    echo  Current version: %CURRENT_VERSION%
) else (
    echo  No version info found - this might be first installation
)

echo.
echo  What would you like to do?
echo.
echo  1. 📥 Check for updates
echo  2. 🔄 Force update (download latest)
echo  3. 📋 View current version info
echo  4. 📖 Show installation guide
echo  5. ❓ Help & troubleshooting
echo  6. 🚪 Exit
echo.
set /p choice="  Select an option (1-6): "

if "%choice%"=="1" goto check_updates
if "%choice%"=="2" goto force_update
if "%choice%"=="3" goto show_version
if "%choice%"=="4" goto show_guide
if "%choice%"=="5" goto show_help
if "%choice%"=="6" goto end
goto invalid_choice

:check_updates
echo.
echo  🔍 Checking for updates...
echo.

:: Check latest version online (simple check)
set LATEST_VERSION=Checking...
powershell -Command "& {try { $web = New-Object System.Net.WebClient; $content = $web.DownloadString('%GITHUB_REPO%'); if($content -match ' PlepperVR ([\d\.]+)') { Write-Host $matches[1] } else { Write-Host 'Unknown' } } catch { Write-Host 'Connection Failed' } }" > temp_version.txt 2>nul

if exist temp_version.txt (
    for /f "tokens=*" %%i in ('type temp_version.txt') do set LATEST_VERSION=%%i
    del temp_version.txt
)

echo  Latest available version: %LATEST_VERSION%
echo  Your current version: %CURRENT_VERSION%

if "%LATEST_VERSION%"=="Connection Failed" (
    echo.
    echo  ❌ Could not check for updates (internet issues?)
    echo.
    choice /C YN /M "  Do you want to try downloading anyway"
    if errorlevel 1 goto force_update
    if errorlevel 2 goto menu
)

if "%LATEST_VERSION%"=="%CURRENT_VERSION%" (
    echo.
    echo  ✅ You have the latest version!
    echo.
    choice /C YN /M "  Do you want to force update anyway"
    if errorlevel 1 goto force_update
    if errorlevel 2 goto menu
)

echo.
choice /C YN /M "  Update to latest version"
if errorlevel 1 goto force_update
if errorlevel 2 goto menu

:force_update
echo.
echo  🚀 Starting update process...
echo.

:: Create backup
set BACKUP_DIR=PlepperVR_Backup_%date:~-4,4%%date:~-7,2%%date:~-10,2%_%time:~0,2%%time:~3,2%
set BACKUP_DIR=%BACKUP_DIR: =0%

echo  📦 Creating backup...
if exist "mods" (
    mkdir "%BACKUP_DIR%" 2>nul
    xcopy "mods" "%BACKUP_DIR%\mods" /E /I /H /Y >nul 2>&1
    if exist "config" xcopy "config" "%BACKUP_DIR%\config" /E /I /H /Y >nul 2>&1
    echo  ✅ Backup created: %BACKUP_DIR%
) else (
    echo  ℹ️  No existing installation found - this is a fresh install
)

:: Download
echo.
echo  📥 Downloading latest PlepperVR...
set DOWNLOAD_URL=%GITHUB_REPO%/archive/refs/heads/main.zip
set ZIP_FILENAME=PlepperVR-latest.zip

:: Try download with multiple methods
where curl >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo  Downloading with curl...
    curl -L --fail -o "%ZIP_FILENAME%" "%DOWNLOAD_URL%" 2>nul
    set DOWNLOAD_RESULT=%ERRORLEVEL%
) else (
    echo  Downloading with PowerShell...
    powershell -Command "Invoke-WebRequest -Uri '%DOWNLOAD_URL%' -OutFile '%ZIP_FILENAME%' -UseBasicParsing" >nul 2>&1
    set DOWNLOAD_RESULT=%ERRORLEVEL%
)

if %DOWNLOAD_RESULT% neq 0 (
    echo  ❌ Download failed! Trying alternative source...
    set DOWNLOAD_URL=%GITHUB_REPO%/archive/refs/heads/master.zip
    where curl >nul 2>&1
    if %ERRORLEVEL% equ 0 (
        curl -L --fail -o "%ZIP_FILENAME%" "%DOWNLOAD_URL%" 2>nul
    ) else (
        powershell -Command "Invoke-WebRequest -Uri '%DOWNLOAD_URL%' -OutFile '%ZIP_FILENAME%' -UseBasicParsing" >nul 2>&1
    )
    set DOWNLOAD_RESULT=%ERRORLEVEL%
)

if %DOWNLOAD_RESULT% neq 0 (
    echo.
    echo  ❌ UPDATE FAILED: Could not download from GitHub
    echo.
    echo  Possible solutions:
    echo  • Check your internet connection
    echo  • Try running as Administrator
    echo  • Temporarily disable antivirus
    echo  • Download manually from: %GITHUB_REPO%
    echo.
    pause
    goto menu
)

:: Verify download
for %%F in ("%ZIP_FILENAME%") do set FILESIZE=%%~zF
if %FILESIZE% lss 1000000 (
    echo  ❌ Downloaded file too small (%FILESIZE% bytes) - likely an error
    del "%ZIP_FILENAME%" 2>nul
    pause
    goto menu
)

echo  ✅ Download completed (%FILESIZE% bytes)

:: Extract
echo.
echo  📂 Extracting files...
set TEMP_DIR=temp_extract_%RANDOM%
mkdir "%TEMP_DIR%"

powershell -Command "Expand-Archive -Path '%ZIP_FILENAME%' -DestinationPath '%TEMP_DIR%' -Force" >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo  ❌ Failed to extract files
    rd /s /q "%TEMP_DIR%" 2>nul
    del "%ZIP_FILENAME%" 2>nul
    pause
    goto menu
)

:: Find extracted directory
for /d %%d in ("%TEMP_DIR%\*") do set EXTRACTED_DIR=%%d

:: Copy files
echo  🔄 Installing updates...
if not exist "mods" mkdir mods
if not exist "config" mkdir config

if exist "!EXTRACTED_DIR!\mods" (
    xcopy "!EXTRACTED_DIR!\mods\*" "mods\" /E /I /H /Y >nul 2>&1
    echo  ✅ Mods updated
)

if exist "!EXTRACTED_DIR!\config" (
    xcopy "!EXTRACTED_DIR!\config\*" "config\" /E /I /H /Y >nul 2>&1
    echo  ✅ Configs updated
)

if exist "!EXTRACTED_DIR!\*.json" (
    copy "!EXTRACTED_DIR!\*.json" . /Y >nul 2>&1
    echo  ✅ Instance files updated
)

:: Update version info
echo %date% %time% > "%VERSION_FILE%"

:: Cleanup
rd /s /q "%TEMP_DIR%" 2>nul
del "%ZIP_FILENAME%" 2>nul

:: Log update
echo [%date% %time%] Update completed > "%UPDATE_LOG%"

echo.
echo  🎉 UPDATE SUCCESSFUL!
echo.
echo  ========================================
echo     PlepperVR has been updated!
echo  ========================================
echo.
echo  What's new:
echo  • Latest mods and configurations
echo  • Bug fixes and improvements
echo  • Performance optimizations
echo.
echo  Backup location: %BACKUP_DIR%
echo.
echo  You can now launch PlepperVR in Prism Launcher!
echo.

choice /C YN /M "  Launch Prism Launcher now"
if errorlevel 1 (
    start "" "https://prismlauncher.org/"
)

goto menu

:show_version
echo.
echo  📋 Version Information
echo  ====================
echo.
if exist "%VERSION_FILE%" (
    echo  Current version: %CURRENT_VERSION%
    echo  Last updated:
    type "%VERSION_FILE%"
) else (
    echo  No version information available
    echo  This might be a fresh installation.
)

if exist "modlist.md" (
    echo.
    echo  📦 Mods installed:
    findstr /C "**" "modlist.md" | findstr /V "##" | findstr /V "Version" | head -10
    echo  ...and many more!
)

echo.
pause
goto menu

:show_guide
echo.
echo  📖 INSTALLATION GUIDE
echo  =====================
echo.
if exist "INSTALL_FRIENDS.md" (
    type "INSTALL_FRIENDS.md"
) else (
    echo  Installation guide not found.
    echo  Check the GitHub repository for instructions.
)
echo.
pause
goto menu

:show_help
echo.
echo  ❓ HELP & TROUBLESHOOTING
echo  =========================
echo.
echo  Common Issues:
echo.
echo  ❌ Game won't start:
echo     • Make sure Java 17+ is installed
echo     • Try running the update again
echo     • Check Prism Launcher settings
echo     • Run ./mmm.exe install in minecraft directory
echo.
echo  ❌ Update fails:
echo     • Check internet connection
echo     • Run as Administrator
echo     • Temporarily disable antivirus
echo.
echo  ❌ Performance issues:
echo     • Allocate 6GB+ RAM in Prism Launcher
echo     • Install on SSD if possible
echo     • Update graphics drivers
echo.
echo  ❌ VR not working:
echo     • Connect VR headset before launching
echo     • Install SteamVR
echo     • Check Vivecraft installation
echo.
echo  Need more help?
echo  📞 Contact: [Your contact info]
echo  🌐 GitHub: %GITHUB_REPO%
echo  💬 Discord: [Link when available]
echo.
pause
goto menu

:invalid_choice
echo.
echo  ❌ Invalid choice. Please select 1-6.
echo.
pause
goto menu

:menu
cls
goto start

:start
echo.
echo  🔄 Return to main menu?
echo.
choice /C YN /M "  Continue with updater"
if errorlevel 1 goto :eof
if errorlevel 2 goto end

:end
echo.
echo  Thanks for using PlepperVR! 🎮
echo.
pause >nul