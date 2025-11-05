@echo off
echo ========================================
echo PlepperVR - Manual Launch Information
echo ========================================
echo.

:: This script provides information for manual launching
:: Prism Launcher handles the actual launching process

echo Prism Launcher Instance: PlepperVR_Test
echo Minecraft Version: 1.20.1
echo Mod Loader: Forge
echo Total Mods: 86 (85 managed by mmm + 1 unmanaged)
echo.

echo To launch PlepperVR manually:
echo ============================
echo.
echo METHOD 1: Use Prism Launcher (Recommended)
echo 1. Launch Prism Launcher
echo 2. Select "PlepperVR_Test" instance
echo 3. Click "Play"
echo.
echo METHOD 2: Command Line Launch
echo 1. Navigate to minecraft directory:
echo    cd "%~dp0minecraft"
echo 2. Use mmm to ensure mods are installed:
echo    ./mmm.exe install
echo 3. Launch via Prism Launcher command line:
echo    "C:\Path\To\PrismLauncher.exe" -l "PlepperVR_Test"
echo.

echo Mod Management:
echo ===============
echo All mods are managed by mmm (Minecraft Mod Manager)
echo Configuration files:
echo   - modlist.json (mmm configuration)
echo   - modlist-lock.json (version lock)
echo   - CLAUDE.md (documentation)
echo.

echo Quick mmm Commands:
echo ===================
echo Navigate to minecraft directory first:
echo   cd "%~dp0minecraft"
echo.
echo Then use:
echo   ./mmm.exe install     - Install all mods
echo   ./mmm.exe update      - Update all mods
echo   ./mmm.exe list        - List all mods
echo   ./mmm.exe add <mod>   - Add new mod
echo   ./mmm.exe remove <mod> - Remove mod
echo.

echo VR Setup:
echo ==========
echo VR Support: Enabled (ImmersiveMC + Vivecraft)
echo Required VR Mods:
echo   - ImmersiveMC (VR interface)
echo   - Vivecraft (main VR mod - manual install)
echo   - Oculus (shaders support)
echo.

echo Performance Optimizations:
echo ==========================
echo - Embeddium (performance)
echo - FerriteCore (memory)
echo - ModernFix (optimizations)
echo - Entity Culling (performance)
echo.

echo Server Information:
echo ==================
echo Server Directory: C:\Users\white\AppData\Roaming\servers\PlepperVR_Server\
echo Use manage_mods.bat to copy mods to server
echo.

echo Troubleshooting:
echo ================
echo If instance doesn't launch:
echo 1. Check Prism Launcher settings
echo 2. Verify Java 17+ is installed
echo 3. Run ./mmm.exe install in minecraft directory
echo 4. Check for missing dependencies
echo.

echo For detailed documentation, see:
echo %~dp0minecraft\CLAUDE.md
echo.
pause