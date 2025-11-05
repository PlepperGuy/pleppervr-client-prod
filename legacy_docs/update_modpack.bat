@echo off
setlocal enabledelayedexpansion

echo ========================================
echo PlepperVR Modpack Updater (Prism + mmm)
echo ========================================
echo.

:: Configuration
set GITHUB_REPO=https://github.com/PlepperGuy/PlepperVR
set ZIP_FILENAME=PlepperVR.zip
set BACKUP_DIR=PlepperVR_Backup_%date:~-4,4%%date:~-7,2%%date:~-10,2%_%time:~0,2%%time:~3,2%
set BACKUP_DIR=%BACKUP_DIR: =0%

:: Navigate to minecraft directory for Prism instance
echo Navigating to minecraft directory...
cd /d "%~dp0minecraft"
echo Now in: %CD%
echo.

:: Create backup of current installation
echo Creating backup of current installation...
if exist "mods" (
    mkdir "%BACKUP_DIR%" 2>nul
    xcopy "mods" "%BACKUP_DIR%\mods" /E /I /H /Y >nul
    echo Backup created: %BACKUP_DIR%
) else (
    echo No existing mods directory found. This appears to be a fresh installation.
)

:: Download latest release from GitHub
echo.
echo Downloading latest PlepperVR release from GitHub...
echo Repository: %GITHUB_REPO%

:: Check if curl is available, fallback to PowerShell if not
echo Checking download tools...
where curl >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo curl not found, using PowerShell for download...
    set USE_POWERSHELL=1
) else (
    echo Using curl for download...
    set USE_POWERSHELL=0
)

:: Set download URLs (main branch since no releases exist yet)
set DOWNLOAD_URL=%GITHUB_REPO%/archive/refs/heads/main.zip
set ZIP_FILENAME=PlepperVR-main.zip
set FALLBACK_URL=%GITHUB_REPO%/archive/refs/heads/master.zip
set FALLBACK_FILENAME=PlepperVR-master.zip

echo Attempting to download from main branch...
echo URL: %DOWNLOAD_URL%
echo.

:: Download using appropriate method
if %USE_POWERSHELL%==1 (
    echo Downloading with PowerShell...
    powershell -Command "& {try { Invoke-WebRequest -Uri '%DOWNLOAD_URL%' -OutFile '%ZIP_FILENAME%' -UseBasicParsing; Write-Host 'Download successful' } catch { Write-Host 'Download failed:' $_.Exception.Message; exit 1 }}"
    set DOWNLOAD_RESULT=%ERRORLEVEL%
) else (
    echo Downloading with curl...
    curl -L --fail -o "%ZIP_FILENAME%" "%DOWNLOAD_URL%"
    set DOWNLOAD_RESULT=%ERRORLEVEL%
)

:: Try fallback if first download failed
if %DOWNLOAD_RESULT% neq 0 (
    echo.
    echo WARNING: Could not download from main branch.
    echo Trying fallback to master branch...
    echo URL: %FALLBACK_URL%
    echo.

    set ZIP_FILENAME=%FALLBACK_FILENAME%

    if %USE_POWERSHELL%==1 (
        echo Downloading with PowerShell...
        powershell -Command "& {try { Invoke-WebRequest -Uri '%FALLBACK_URL%' -OutFile '%ZIP_FILENAME%' -UseBasicParsing; Write-Host 'Download successful' } catch { Write-Host 'Download failed:' $_.Exception.Message; exit 1 }}"
        set DOWNLOAD_RESULT=%ERRORLEVEL%
    ) else (
        echo Downloading with curl...
        curl -L --fail -o "%ZIP_FILENAME%" "%FALLBACK_URL%"
        set DOWNLOAD_RESULT=%ERRORLEVEL%
    )
)

:: Verify download success
if %DOWNLOAD_RESULT% neq 0 (
    echo.
    echo ERROR: Failed to download the modpack from all sources.
    echo Please check your internet connection and try again.
    echo You can also download manually from: %GITHUB_REPO%
    pause
    exit /b 1
)

echo Download completed successfully!

:: Verify the file was downloaded and has content
if not exist "%ZIP_FILENAME%" (
    echo.
    echo ERROR: Downloaded file not found.
    pause
    exit /b 1
)

:: Check if file is too small (likely an error page)
for %%F in ("%ZIP_FILENAME%") do set FILESIZE=%%~zF
if %FILESIZE% lss 100000 (
    echo.
    echo WARNING: Downloaded file is very small (%FILESIZE% bytes)
    echo This might be an error page instead of the actual zip file.
    echo.
    choice /C YN /M "Do you want to continue anyway"
    if errorlevel 2 exit /b 1
)

:: Extract the modpack
echo.
echo Extracting modpack...
if exist "%ZIP_FILENAME%" (
    :: Create temporary extraction directory
    set TEMP_DIR=temp_extract_%RANDOM%
    mkdir "%TEMP_DIR%"

    :: Extract using Windows built-in tar (Windows 10+) or fallback
    tar -xf "%ZIP_FILENAME%" -C "%TEMP_DIR%" 2>nul
    if %ERRORLEVEL% neq 0 (
        echo Trying alternative extraction method...
        powershell -Command "Expand-Archive -Path '%ZIP_FILENAME%' -DestinationPath '%TEMP_DIR%' -Force"
    )

    if %ERRORLEVEL% neq 0 (
        echo.
        echo ERROR: Failed to extract the modpack.
        echo Please ensure you have Windows 10+ or install 7-Zip.
        rd /s /q "%TEMP_DIR%" 2>nul
        pause
        exit /b 1
    )

    :: Find the extracted directory
    for /d %%d in ("%TEMP_DIR%\*") do (
        set EXTRACTED_DIR=%%d
    )

    if "!EXTRACTED_DIR!"=="" (
        echo ERROR: Could not find extracted directory.
        rd /s /q "%TEMP_DIR%" 2>nul
        pause
        exit /b 1
    )

    :: Copy/Update files
    echo Installing/updating modpack files...

    :: Create directories if they don't exist
    if not exist "mods" mkdir mods
    if not exist "config" mkdir config

    :: Copy mods (this will update the actual mod files)
    if exist "!EXTRACTED_DIR!\mods" (
        echo Updating mods...
        xcopy "!EXTRACTED_DIR!\mods\*" "mods\" /E /I /H /Y
    )

    :: Copy configs
    if exist "!EXTRACTED_DIR!\config" (
        echo Updating configs...
        xcopy "!EXTRACTED_DIR!\config\*" "config\" /E /I /H /Y
    )

    :: Copy mmm configuration if available
    if exist "!EXTRACTED_DIR!\modlist.json" (
        echo Updating mmm configuration...
        copy "!EXTRACTED_DIR!\modlist.json" . /Y
    )

    if exist "!EXTRACTED_DIR!\modlist-lock.json" (
        echo Updating mmm version lock...
        copy "!EXTRACTED_DIR!\modlist-lock.json" . /Y
    )

    if exist "!EXTRACTED_DIR!\mmm.exe" (
        echo Updating mmm executable...
        copy "!EXTRACTED_DIR!\mmm.exe" . /Y
    )

    :: Copy other important files
    if exist "!EXTRACTED_DIR!\*.json" (
        echo Updating instance files...
        copy "!EXTRACTED_DIR!\*.json" . /Y
    )

    if exist "!EXTRACTED_DIR!\*.toml" (
        copy "!EXTRACTED_DIR!\*.toml" . /Y
    )

    :: Cleanup
    rd /s /q "%TEMP_DIR%" 2>nul

    echo.
    echo ========================================
    echo UPDATE COMPLETED SUCCESSFULLY!
    echo ========================================
    echo.
    echo Modpack has been installed/updated for Prism Launcher.
    echo Backup created: %BACKUP_DIR%
    echo Downloaded file: %ZIP_FILENAME%
    echo.
    echo Next steps:
    echo 1. Launch Prism Launcher
    echo 2. Start the PlepperVR_Test instance
    echo 3. Use manage_mods.bat for mod management with mmm
    echo.

) else (
    echo ERROR: Downloaded file not found.
    pause
    exit /b 1
)

:: Cleanup download file (optional - uncomment if you want to auto-delete)
:: del "%ZIP_FILENAME%"

echo.
echo Press any key to exit...
pause >nul