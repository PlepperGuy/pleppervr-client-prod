@echo off
echo ========================================
echo PlepperVR Prism Environment Setup
echo ========================================
echo.

:: This script sets up the Prism Launcher + mmm environment
:: Note: This instance should already be configured in Prism Launcher

echo Setting up Prism Launcher environment...
echo.

:: Navigate to minecraft directory
echo Navigating to minecraft directory...
cd /d "%~dp0minecraft"
echo Now in: %CD%
echo.

:: Check if mmm exists
if exist "mmm.exe" (
    echo ✅ mmm.exe found in minecraft directory
) else (
    echo ❌ mmm.exe not found in minecraft directory
    echo Please ensure mmm is properly installed.
    echo You can download mmm from: https://github.com/Ghost-chu/minecraft-mod-manager
    echo.
    pause
    exit /b 1
)

:: Check modlist configuration
if exist "modlist.json" (
    echo ✅ modlist.json configuration found
) else (
    echo ❌ modlist.json not found
    echo Please ensure mmm configuration exists.
)

if exist "modlist-lock.json" (
    echo ✅ modlist-lock.json version lock found
) else (
    echo ⚠️ modlist-lock.json not found - will be created after first install
)

:: Create server directory structure
echo.
echo Creating server directories...
if not exist "C:\Users\white\AppData\Roaming\servers\PlepperVR_Server" mkdir "C:\Users\white\AppData\Roaming\servers\PlepperVR_Server"
if not exist "C:\Users\white\AppData\Roaming\servers\PlepperVR_Server\mods" mkdir "C:\Users\white\AppData\Roaming\servers\PlepperVR_Server\mods"

:: Show current status
echo.
echo Current setup status:
echo ====================
echo ✅ Prism Launcher Instance: PlepperVR_Test
echo ✅ Minecraft Directory: %CD%
echo ✅ mmm Configuration: modlist.json
echo ✅ Server Directory: C:\Users\white\AppData\Roaming\servers\PlepperVR_Server\
echo.

echo Next steps:
echo 1. Launch Prism Launcher and start the PlepperVR_Test instance
echo 2. Use manage_mods.bat to manage mods with mmm
echo 3. Mods are managed through mmm commands:
echo    ./mmm.exe install     - Install all mods from configuration
echo    ./mmm.exe update      - Update all mods to latest versions
echo    ./mmm.exe list        - Show all managed mods
echo    ./mmm.exe add <mod>   - Add new mod
echo.

echo Setup complete! This Prism instance is ready for mod management with mmm.
echo.
pause