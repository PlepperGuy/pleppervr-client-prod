@echo off
setlocal enabledelayedexpansion

:: PlepperVR Version Management and Rollback Script
:: Allows users to manage different versions and rollback if needed

color 0E

echo.
echo  ██████╗ ██████╗ ███╗   ██╗███████╗██╗ ██████╗ ██╗   ██╗███████╗███╗   ██╗██████╗
echo  ██╔══██╗██╔══██╗████╗  ██║██╔════╝██║██╔═══██╗██║   ██║██╔════╝████╗  ██║██╔══██╗
echo  ██████╔╝██████╔╝██╔██╗ ██║█████╗  ██║██║   ██║██║   ██║█████╗  ██╔██╗ ██║██████╔╝
echo  ██╔══██╗██╔══██╗██║╚██╗██║██╔══╝  ██║██║   ██║╚██╗ ██╔╝██╔══╝  ██║╚██╗██║██╔═══╝
echo  ██║  ██║██████╔╝██║ ╚████║██║     ██║╚██████╔╝ ╚████╔╝ ███████╗██║ ╚████║██║
echo  ╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝   ╚═══╝  ╚══════╝╚═╝  ╚═══╝╚═╝
echo.
echo  ========================================
echo     PlepperVR Version Manager v1.0
echo  ========================================
echo.

:: Configuration
set VERSIONS_DIR=PlepperVR_Versions
set CURRENT_VERSION_FILE=current_version.txt
set VERSION_LOG=version_history.log

:main_menu
cls
echo.
echo  📋 VERSION MANAGEMENT MENU
echo  =========================
echo.
echo  Current status:
if exist "%CURRENT_VERSION_FILE%" (
    for /f "tokens=*" %%i in ('type "%CURRENT_VERSION_FILE%"') do set CURRENT_VER=%%i
    echo  ✅ Current version: %CURRENT_VER%
) else (
    echo  ❌ No version information available
)

echo.
echo  Available actions:
echo.
echo  1. 📥 Download and install specific version
echo  2. 📚 View available versions
echo  3. 🔄 Rollback to previous version
echo  4. 📊 Show version history
echo  5. 💾 Create manual backup
echo  6. 🗂️  Manage local versions
echo  7. ❓ Help and information
echo  8. 🚪 Exit
echo.
set /p choice="  Select an option (1-8): "

if "%choice%"=="1" goto download_version
if "%choice%"=="2" goto view_versions
if "%choice%"=="3" goto rollback_version
if "%choice%"=="4" goto show_history
if "%choice%"=="5" goto create_backup
if "%choice%"=="6" goto manage_versions
if "%choice%"=="7" goto show_help
if "%choice%"=="8" goto end
goto invalid_choice

:download_version
echo.
echo  📥 DOWNLOAD SPECIFIC VERSION
echo  ===========================
echo.
echo  Available versions to download:
echo.
echo  1. Latest version (recommended)
echo  2. Version 1.1.0 (November 2025)
echo  3. Version 1.0.0 (Initial release)
echo  4. Enter custom commit hash/branch
echo.
set /p ver_choice="  Select version to download (1-4): "

if "%ver_choice%"=="1" (
    set DOWNLOAD_BRANCH=main
    set VERSION_NAME=Latest
) else if "%ver_choice%"=="2" (
    set DOWNLOAD_BRANCH=release-v1.1.0
    set VERSION_NAME=v1.1.0
) else if "%ver_choice%"=="3" (
    set DOWNLOAD_BRANCH=release-v1.0.0
    set VERSION_NAME=v1.0.0
) else if "%ver_choice%"=="4" (
    set /p CUSTOM_BRANCH="  Enter branch/tag/commit: "
    set DOWNLOAD_BRANCH=%CUSTOM_BRANCH%
    set VERSION_NAME=Custom-%CUSTOM_BRANCH%
) else (
    echo  ❌ Invalid choice
    pause
    goto main_menu
)

echo.
echo  Downloading version: %VERSION_NAME%
echo  From branch: %DOWNLOAD_BRANCH%
echo.
choice /C YN /M "  Continue with download"
if errorlevel 2 goto main_menu

:: Create backup before downloading
call :create_auto_backup

:: Download specified version
set GITHUB_REPO=https://github.com/PlepperGuy/PlepperVR
set DOWNLOAD_URL=%GITHUB_REPO%/archive/refs/heads/%DOWNLOAD_BRANCH%.zip
set ZIP_FILENAME=PlepperVR-%VERSION_NAME%.zip

echo  📥 Downloading from GitHub...
where curl >nul 2>&1
if %ERRORLEVEL% equ 0 (
    curl -L --fail -o "%ZIP_FILENAME%" "%DOWNLOAD_URL%" 2>nul
    set DOWNLOAD_RESULT=%ERRORLEVEL%
) else (
    powershell -Command "Invoke-WebRequest -Uri '%DOWNLOAD_URL%' -OutFile '%ZIP_FILENAME%' -UseBasicParsing" >nul 2>&1
    set DOWNLOAD_RESULT=%ERRORLEVEL%
)

if %DOWNLOAD_RESULT% neq 0 (
    echo  ❌ Download failed! Branch/tag may not exist.
    pause
    goto main_menu
)

:: Create version directory
if not exist "%VERSIONS_DIR%" mkdir "%VERSIONS_DIR%"
set VERSION_INSTALL_DIR=%VERSIONS_DIR%\%VERSION_NAME%
if exist "%VERSION_INSTALL_DIR%" rd /s /q "%VERSION_INSTALL_DIR%"
mkdir "%VERSION_INSTALL_DIR%"

:: Extract to version directory
echo  📂 Extracting files...
powershell -Command "Expand-Archive -Path '%ZIP_FILENAME%' -DestinationPath '%VERSION_INSTALL_DIR%' -Force" >nul 2>&1

if %ERRORLEVEL% neq 0 (
    echo  ❌ Failed to extract files
    del "%ZIP_FILENAME%" 2>nul
    pause
    goto main_menu
)

:: Find extracted directory and move files
for /d %%d in ("%VERSION_INSTALL_DIR%\*") do set EXTRACTED_DIR=%%d
if exist "!EXTRACTED_DIR!" (
    xcopy "!EXTRACTED_DIR!\*" "%VERSION_INSTALL_DIR%\" /E /I /H /Y >nul 2>&1
    rd /s /q "!EXTRACTED_DIR!" 2>nul
)

:: Update current version
echo %VERSION_NAME% > "%CURRENT_VERSION_FILE%"
echo [%date% %time%] Installed version: %VERSION_NAME% >> "%VERSION_LOG%"

:: Cleanup
del "%ZIP_FILENAME%" 2>nul

echo.
echo  ✅ Version %VERSION_NAME% downloaded successfully!
echo  Location: %VERSION_INSTALL_DIR%
echo.
choice /C YN /M "  Activate this version now"
if errorlevel 1 goto activate_version
goto main_menu

:activate_version
echo.
echo  🔄 Activating version %VERSION_NAME%...

:: Create backup of current installation
call :create_auto_backup

:: Copy files from version directory
if exist "%VERSION_INSTALL_DIR%\mods" (
    if not exist "mods" mkdir mods
    xcopy "%VERSION_INSTALL_DIR%\mods\*" "mods\" /E /I /H /Y >nul 2>&1
    echo  ✅ Mods updated
)

if exist "%VERSION_INSTALL_DIR%\config" (
    if not exist "config" mkdir config
    xcopy "%VERSION_INSTALL_DIR%\config\*" "config\" /E /I /H /Y >nul 2>&1
    echo  ✅ Configs updated
)

if exist "%VERSION_INSTALL_DIR%\*.json" (
    copy "%VERSION_INSTALL_DIR%\*.json" . /Y >nul 2>&1
    echo  ✅ Instance files updated
)

echo.
echo  🎉 Version %VERSION_NAME% is now active!
pause
goto main_menu

:view_versions
echo.
echo  📚 AVAILABLE VERSIONS
echo  =====================
echo.

:: Check online versions
echo  🔍 Checking GitHub for available versions...
echo.
powershell -Command "& {try { $web = New-Object System.Net.WebClient; $branches = $web.DownloadString('https://api.github.com/repos/PlepperGuy/PlepperVR/branches'); $branches | ConvertFrom-Json | ForEach-Object { Write-Host \"Branch: $($_.name)\" } } catch { Write-Host 'Could not fetch branch list' } }" 2>nul

echo.
echo  📁 Local versions available:
if exist "%VERSIONS_DIR%" (
    for /d %%d in ("%VERSIONS_DIR%\*") do (
        echo    📦 %%~nd
    )
) else (
    echo    No local versions found
)

echo.
pause
goto main_menu

:rollback_version
echo.
echo  🔄 ROLLBACK TO PREVIOUS VERSION
echo  =============================
echo.

if not exist "%VERSIONS_DIR%" (
    echo  ❌ No local versions found for rollback
    echo  Download some versions first (Option 1)
    pause
    goto main_menu
)

echo  Available local versions:
set count=0
for /d %%d in ("%VERSIONS_DIR%\*") do (
    set /a count+=1
    echo  !count!. %%~nd
    set version!count!=%%~nd
)

if %count% equ 0 (
    echo  No versions available for rollback
    pause
    goto main_menu
)

echo.
set /p rollback_choice="  Select version to rollback to (1-%count%): "

if %rollback_choice% gtr 0 if %rollback_choice% leq %count% (
    for %%i in (1,2,3,4,5,6,7,8,9) do (
        if !rollback_choice!==%%i set SELECTED_VERSION=!version%%i!
    )

    echo.
    echo  Selected version: !SELECTED_VERSION!
    choice /C YN /M "  Confirm rollback to this version"
    if errorlevel 2 goto main_menu

    :: Perform rollback
    set VERSION_NAME=!SELECTED_VERSION!
    set VERSION_INSTALL_DIR=%VERSIONS_DIR%\!SELECTED_VERSION!
    goto activate_version
) else (
    echo  ❌ Invalid choice
    pause
    goto main_menu
)

:show_history
echo.
echo  📊 VERSION HISTORY
echo  ==================
echo.

if exist "%VERSION_LOG%" (
    type "%VERSION_LOG%"
) else (
    echo  No version history available
)

echo.
pause
goto main_menu

:create_backup
echo.
echo  💾 CREATE MANUAL BACKUP
echo  =======================
echo.
set /p backup_name="  Enter backup name (or press Enter for timestamp): "
if "%backup_name%"=="" set backup_name=Manual_%date:~-4,4%%date:~-7,2%%date:~-10,2%_%time:~0,2%%time:~3,2%
set backup_name=%backup_name: =0%

set BACKUP_DIR=Backup_%backup_name%
if exist "%BACKUP_DIR%" (
    echo  ❌ Backup directory already exists!
    pause
    goto main_menu
)

mkdir "%BACKUP_DIR%" 2>nul

if exist "mods" xcopy "mods" "%BACKUP_DIR%\mods\" /E /I /H /Y >nul 2>&1
if exist "config" xcopy "config" "%BACKUP_DIR%\config\" /E /I /H /Y >nul 2>&1
if exist "*.json" copy "*.json" "%BACKUP_DIR%\" /Y >nul 2>&1
if exist "*.toml" copy "*.toml" "%BACKUP_DIR%\" /Y >nul 2>&1

echo [%date% %time%] Created manual backup: %backup_name% >> "%VERSION_LOG%"

echo.
echo  ✅ Backup created: %BACKUP_DIR%
pause
goto main_menu

:manage_versions
echo.
echo  🗂️  MANAGE LOCAL VERSIONS
echo  ========================
echo.

if not exist "%VERSIONS_DIR%" (
    echo  No local versions found
    pause
    goto main_menu
)

echo  Available versions:
set count=0
for /d %%d in ("%VERSIONS_DIR%\*") do (
    set /a count+=1
    echo  !count!. %%~nd
    set version!count!=%%~nd
)

echo.
echo  Actions:
echo  1. Delete version
echo  2. Rename version
echo  3. View version details
echo  4. Back to main menu
echo.
set /p manage_choice="  Select action (1-4): "

if "%manage_choice%"=="1" goto delete_version
if "%manage_choice%"=="2" goto rename_version
if "%manage_choice%"=="3" goto view_version_details
if "%manage_choice%"=="4" goto main_menu
goto manage_versions

:delete_version
echo.
set /p delete_choice="  Select version to delete (1-%count%): "
if %delete_choice% gtr 0 if %delete_choice% leq %count% (
    for %%i in (1,2,3,4,5,6,7,8,9) do (
        if !delete_choice!==%%i set DELETE_VERSION=!version%%i!
    )

    echo  Selected: !DELETE_VERSION!
    choice /C YN /M "  Permanently delete this version"
    if errorlevel 2 goto manage_versions

    rd /s /q "%VERSIONS_DIR%\!DELETE_VERSION!" 2>nul
    echo  ✅ Version deleted
)
pause
goto manage_versions

:rename_version
echo.
set /p rename_choice="  Select version to rename (1-%count%): "
if %rename_choice% gtr 0 if %rename_choice% leq %count% (
    for %%i in (1,2,3,4,5,6,7,8,9) do (
        if !rename_choice!==%%i set RENAME_VERSION=!version%%i!
    )

    echo  Selected: !RENAME_VERSION!
    set /p new_name="  Enter new name: "

    if not "%new_name%"=="" (
        ren "%VERSIONS_DIR%\!RENAME_VERSION!" "%new_name%" 2>nul
        if !errorlevel! equ 0 (
            echo  ✅ Version renamed to: %new_name%
        ) else (
            echo  ❌ Rename failed
        )
    )
)
pause
goto manage_versions

:view_version_details
echo.
set /p view_choice="  Select version to view (1-%count%): "
if %view_choice% gtr 0 if %view_choice% leq %count% (
    for %%i in (1,2,3,4,5,6,7,8,9) do (
        if !view_choice!==%%i set VIEW_VERSION=!version%%i!
    )

    echo  Details for: !VIEW_VERSION!
    echo  Location: %VERSIONS_DIR%\!VIEW_VERSION!
    echo.

    if exist "%VERSIONS_DIR%\!VIEW_VERSION!\mods" (
        for /f %%i in ('dir "%VERSIONS_DIR%\!VIEW_VERSION!\mods\*.jar" /b 2^>nul ^| find /c /v ""') do echo  Mods: %%i
    )

    if exist "%VERSIONS_DIR%\!VIEW_VERSION!\config" (
        echo  Configs: Available
    )

    if exist "%VERSIONS_DIR%\!VIEW_VERSION!\*.json" (
        echo  Instance files: Available
    )
)
pause
goto manage_versions

:show_help
echo.
echo  ❓ VERSION MANAGER HELP
echo  =======================
echo.
echo  What this tool does:
echo  • Download and manage different PlepperVR versions
echo  • Rollback to previous versions if updates cause issues
echo  • Create manual backups before making changes
echo  • Keep track of version history
echo.
echo  When to use:
echo  • New update breaks something: Rollback to working version
echo  • Want to try older version: Download and activate it
echo  • Before major changes: Create manual backup
echo  • Troubleshooting: Switch between versions to isolate issues
echo.
echo  Tips:
echo  • Always create backup before updating
echo  • Keep multiple versions for testing
echo  • Delete old versions you no longer need to save space
echo  • Check version history to see what changed
echo.
echo  File locations:
echo  • Versions: %VERSIONS_DIR%\
echo  • History: %VERSION_LOG%
echo  • Current version: %CURRENT_VERSION_FILE%
echo.
pause
goto main_menu

:create_auto_backup
:: Creates automatic backup with timestamp
set AUTO_BACKUP=Auto_Backup_%date:~-4,4%%date:~-7,2%%date:~-10,2%_%time:~0,2%%time:~3,2%
set AUTO_BACKUP=%AUTO_BACKUP: =0%
mkdir "%AUTO_BACKUP%" 2>nul
if exist "mods" xcopy "mods" "%AUTO_BACKUP%\mods\" /E /I /H /Y >nul 2>&1
if exist "config" xcopy "config" "%AUTO_BACKUP%\config\" /E /I /H /Y >nul 2>&1
goto :eof

:invalid_choice
echo.
echo  ❌ Invalid choice. Please select 1-8.
echo.
pause
goto main_menu

:end
echo.
echo  Thanks for using PlepperVR Version Manager! 🎮
echo.
pause >nul