@echo off
echo ========================================
echo PlepperVR Mod Management Script (Prism + mmm)
echo ========================================
echo.

:: Check current directory
echo Current working directory: %CD%
echo.

:: Menu
echo Select an option:
echo 1. Navigate to minecraft directory
echo 2. Add mods from Modrinth/CurseForge
echo 3. Download/Update all mods (mmm install)
echo 4. List current mods (mmm list)
echo 5. Copy mods to server
echo 6. Update modlist.md
echo 7. Scan for unmanaged mods
echo 8. Clean up orphaned files
echo 9. Exit
echo.
set /p choice="Enter your choice (1-9): "

if "%choice%"=="1" goto navigate_minecraft
if "%choice%"=="2" goto add_mods
if "%choice%"=="3" goto upgrade_mods
if "%choice%"=="4" goto list_mods
if "%choice%"=="5" goto copy_mods
if "%choice%"=="6" goto update_docs
if "%choice%"=="7" goto scan_mods
if "%choice%"=="8" goto cleanup
if "%choice%"=="9" goto end

:navigate_minecraft
echo Navigating to minecraft directory...
cd /d "%~dp0minecraft"
echo Now in: %CD%
echo.
echo You can now run mmm commands directly:
echo   ./mmm.exe install
echo   ./mmm.exe add modrinth <mod-id>
echo   ./mmm.exe list
echo.
goto end

:add_mods
echo.
echo Adding mods with mmm...
echo.
echo Example mod additions:
echo   ./mmm.exe add modrinth embeddium
echo   ./mmm.exe add curseforge 306612
echo   ./mmm.exe add github owner/repo
echo.
echo Navigate to minecraft directory first (option 1), then run commands manually.
echo.
goto end

:upgrade_mods
echo Installing/Updating all mods...
cd /d "%~dp0minecraft"
if exist "mmm.exe" (
    echo Running mmm install...
    ./mmm.exe install
) else (
    echo ERROR: mmm.exe not found in minecraft directory
    echo Please ensure mmm is properly installed.
)
goto end

:list_mods
echo Listing current mods...
cd /d "%~dp0minecraft"
if exist "mmm.exe" (
    echo Running mmm list...
    ./mmm.exe list
) else (
    echo ERROR: mmm.exe not found in minecraft directory
    echo Please ensure mmm is properly installed.
)
goto end

:copy_mods
echo.
echo Select destination:
echo 1. Test Server
echo 2. Production Server
set /p server_choice="Enter choice (1-2): "

if "%server_choice%"=="1" (
    echo Copying to Test Server...
    xcopy "%~dp0minecraft\mods\*.jar" "C:\Users\white\AppData\Roaming\PrismLauncher\instances\PlepperVR_Test_Server\mods\" /Y
    echo Copied to test server directory.
) else if "%server_choice%"=="2" (
    echo Copying to Production Server...
    xcopy "%~dp0minecraft\mods\*.jar" "C:\Users\white\AppData\Roaming\PrismLauncher\instances\PlepperVR_Server\mods\" /Y
    echo Copied to production server directory.
)
goto end

:update_docs
echo.
echo Documentation update options:
echo 1. Quick mod count update
echo 2. Full documentation refresh
set /p doc_choice="Enter choice (1-2): "

if "%doc_choice%"=="1" (
    echo Quick update - updating mod count...
    cd /d "%~dp0minecraft"
    if exist "mods" (
        for /f %%i in ('dir "mods\*.jar" /b 2^>nul ^| find /c /v ""') do echo Total mods: %%i
    )
) else if "%doc_choice%"=="2" (
    echo Opening CLAUDE.md for manual editing...
    notepad "%~dp0minecraft\CLAUDE.md"
)
goto end

:scan_mods
echo Scanning for unmanaged mods...
cd /d "%~dp0minecraft"
if exist "mmm.exe" (
    echo Running mmm scan...
    ./mmm.exe scan --add
) else (
    echo ERROR: mmm.exe not found in minecraft directory
)
goto end

:cleanup
echo Cleaning up orphaned files...
cd /d "%~dp0minecraft"
if exist "mmm.exe" (
    echo Running mmm prune...
    ./mmm.exe prune -f
) else (
    echo ERROR: mmm.exe not found in minecraft directory
)
goto end

:end
echo.
echo Operation completed.
pause