@echo off
echo Updating PlepperVR Modpack...

:: Navigate to minecraft directory for mmm operations
if exist "minecraft" (
    cd minecraft
) else (
    echo Error: minecraft directory not found
    echo Please run this script from the pleppervr-client-testing root directory
    pause
    exit /b 1
)

:: Check if mmm.exe exists
if not exist "mmm.exe" (
    echo Error: mmm.exe not found
    echo Please ensure Minecraft Mod Manager is properly installed
    pause
    exit /b 1
)

:: Check if modlist.json exists
if not exist "modlist.json" (
    echo Error: modlist.json not found
    echo Please ensure mod configuration is properly set up
    pause
    exit /b 1
)

echo.
echo Current mod configuration:
echo ========================
mmm.exe list

echo.
echo Checking for mod updates...
mmm.exe outdated

echo.
echo Updating all mods to latest versions...
mmm.exe update

if %errorlevel% equ 0 (
    echo.
    echo Mod update completed successfully!

    echo.
    echo Verifying installation...
    mmm.exe list

    echo.
    echo Updated mod list written to modlist-lock.json
    echo Remember to commit the updated files to Git:
    echo   - modlist.json
    echo   - modlist-lock.json
    echo   - minecraft/mods/ directory
) else (
    echo.
    echo Error: Mod update failed
    echo Please check the error messages above
)

cd ..
echo.
echo Update process completed.
pause