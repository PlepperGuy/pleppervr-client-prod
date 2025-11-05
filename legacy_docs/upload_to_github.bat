@echo off
setlocal enabledelayedexpansion

echo ========================================
echo PlepperVR GitHub Uploader
echo ========================================
echo.

:: Configuration
set ORIGINAL_FILENAME=PlepperVR 1.20.1.zip
set TARGET_FILENAME=PlepperVR-main.zip
set REPO_URL=https://github.com/PlepperGuy/PlepperVR

:: Check if original file exists
echo Checking for original modpack file...
if not exist "%ORIGINAL_FILENAME%" (
    echo.
    echo ERROR: %ORIGINAL_FILENAME% not found!
    echo Please make sure this file is in the current directory.
    echo.
    echo Current directory: %CD%
    echo.
    dir *.zip 2>nul
    pause
    exit /b 1
)

echo Found: %ORIGINAL_FILENAME%
echo Target name: %TARGET_FILENAME%
echo.

:: Get file info
for %%F in ("%ORIGINAL_FILENAME%") do set FILESIZE=%%~zF
set /a FILESIZE_MB=%FILESIZE%/1048576
echo File size: %FILESIZE_MB% MB (%FILESIZE% bytes)
echo.

:: Check if target file already exists
if exist "%TARGET_FILENAME%" (
    echo WARNING: %TARGET_FILENAME% already exists.
    choice /C YN /M "Do you want to overwrite it"
    if errorlevel 2 (
        echo Upload cancelled.
        pause
        exit /b 1
    )
)

:: Rename the file
echo Renaming %ORIGINAL_FILENAME% to %TARGET_FILENAME%...
rename "%ORIGINAL_FILENAME%" "%TARGET_FILENAME%"

if %ERRORLEVEL% neq 0 (
    echo.
    echo ERROR: Failed to rename file.
    echo Please make sure the file is not in use.
    pause
    exit /b 1
)

echo Rename completed successfully!
echo.

:: Check if Git is available
echo Checking for Git...
where git >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo.
    echo ERROR: Git is not installed or not in PATH.
    echo.
    echo To install Git:
    echo 1. Download from: https://git-scm.com/download/win
    echo 2. Run the installer
    echo 3. Restart command prompt
    echo.
    pause
    exit /b 1
)

echo Git found!
echo.

:: Check if we're in a git repository
echo Checking Git repository...
if not exist ".git" (
    echo Not in a Git repository. Initializing...
    git init >nul 2>&1
    if %ERRORLEVEL% neq 0 (
        echo ERROR: Failed to initialize Git repository.
        pause
        exit /b 1
    )
    git remote add origin %REPO_URL% >nul 2>&1
    echo Repository initialized.
) else (
    echo Git repository found.
)

:: Check if remote is configured correctly
git remote get-url origin >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo Setting up remote...
    git remote add origin %REPO_URL% >nul 2>&1
)

:: Get current date for commit message
set YEAR=%date:~-4%
set MONTH=%date:~-7,2%
set DAY=%date:~-10,2%
set HOUR=%time:~0,2%
set MINUTE=%time:~3,2%
set TIMESTAMP=%YEAR%-%MONTH%-%DAY% %HOUR%:%MINUTE%
set TIMESTAMP=%TIMESTAMP: =0%

echo ========================================
echo Ready to upload to GitHub
echo ========================================
echo.
echo Repository: %REPO_URL%
echo File: %TARGET_FILENAME%
echo Size: %FILESIZE_MB% MB
echo Timestamp: %TIMESTAMP%
echo.

:: Confirm upload
choice /C YN /M "Do you want to upload this file to GitHub"
if errorlevel 2 (
    echo Upload cancelled.
    pause
    exit /b 1
)

echo.
echo Uploading to GitHub...
echo This may take a while depending on file size and internet speed.
echo.

:: Add the file to git
echo Adding file to repository...
git add "%TARGET_FILENAME%"

if %ERRORLEVEL% neq 0 (
    echo ERROR: Failed to add file to Git.
    pause
    exit /b 1
)

:: Create commit
echo Creating commit...
git commit -m "Update PlepperVR modpack - %TIMESTAMP%

Changes:
- Updated Prism Launcher instance for %TIMESTAMP%
- Complete modpack with all latest mods and configurations
- Managed by Minecraft Mod Manager (mmm) - 86 mods total
- Compatible with Minecraft 1.20.1 Forge
- File size: %FILESIZE_MB% MB

🤖 Generated with automated upload script

Co-Authored-By: Claude <noreply@anthropic.com>" >nul 2>&1

if %ERRORLEVEL% neq 0 (
    echo ERROR: Failed to create commit.
    echo This might happen if there are no changes to commit.
    pause
    exit /b 1
)

:: Check current branch
for /f "tokens=*" %%i in ('git branch --show-current') do set CURRENT_BRANCH=%%i
echo Current branch: %CURRENT_BRANCH%

:: Push to GitHub
echo Pushing to GitHub...
git push origin %CURRENT_BRANCH% --force

set PUSH_RESULT=%ERRORLEVEL%

echo.

:: Check result
if %PUSH_RESULT% equ 0 (
    echo ========================================
    echo UPLOAD SUCCESSFUL!
    echo ========================================
    echo.
    echo File uploaded to: %REPO_URL%
    echo You can now use the update scripts to download this version.
    echo.
    echo Update scripts will now be able to download: %TARGET_FILENAME%
    echo.

    :: Offer to open repository page
    choice /C YN /M "Do you want to open the GitHub repository page"
    if errorlevel 1 (
        start "" "%REPO_URL%"
    )

) else (
    echo ========================================
    echo UPLOAD FAILED!
    echo ========================================
    echo.
    echo Error code: %PUSH_RESULT%
    echo.
    echo Possible issues:
    echo - Network connection problems
    echo - Git authentication issues
    echo - Repository permissions problem
    echo - Branch protection rules
    echo.
    echo Troubleshooting:
    echo 1. Check your internet connection
    echo 2. Try: git config --global user.name "Your Name"
    echo 3. Try: git config --global user.email "your.email@example.com"
    echo 4. Make sure you have push access to the repository
    echo.
    echo You can also try manual upload via GitHub website.
)

echo Press any key to exit...
pause >nul