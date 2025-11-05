@echo off
echo Uploading PlepperVR Client to GitHub...

:: Check if git is available
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Git is not installed or not in PATH
    echo Please install Git and try again
    pause
    exit /b 1
)

:: Check if we're in a git repository
if not exist ".git" (
    echo Error: Not a git repository
    echo Please initialize git repository first: git init
    pause
    exit /b 1
)

:: Show current status
echo.
echo Current git status:
git status --short

echo.
echo Available changes:
git status --porcelain

:: Ask user for commit message
echo.
set /p commit_msg="Enter commit message: "
if "%commit_msg%"=="" (
    echo Error: Commit message cannot be empty
    pause
    exit /b 1
)

:: Add all files
echo.
echo Adding all files to git...
git add .

:: Commit changes
echo.
echo Committing changes...
git commit -m "%commit_msg%"

:: Check if remote exists and push
git remote get-url origin >nul 2>&1
if %errorlevel% equ 0 (
    echo.
    echo Pushing to GitHub...
    git push origin master
    if %errorlevel% equ 0 (
        echo Successfully pushed to GitHub!
    ) else (
        echo Error: Failed to push to GitHub
        echo Please check your internet connection and repository access
    )
) else (
    echo Warning: No remote 'origin' found
    echo To add remote: git remote add origin https://github.com/PlepperGuy/pleppervr-client-testing.git
    echo Then run: git push -u origin master
)

echo.
echo Upload process completed.
pause