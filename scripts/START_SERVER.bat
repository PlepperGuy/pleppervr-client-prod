@echo off
echo Starting Minecraft Forge Server...

:: Configuration
set MIN_RAM=4G
set MAX_RAM=8G
set SERVER_JAR=forge-1.20.1-47.2.20.jar

:: Check if Java is available
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Java is not installed or not in PATH
    echo Please install Java 17 or higher and try again
    pause
    exit /b 1
)

:: Check if server jar exists
if not exist "%SERVER_JAR%" (
    echo Error: Server jar file not found: %SERVER_JAR%
    echo Please ensure Forge server is properly installed
    pause
    exit /b 1
)

:: Check if EULA is accepted
if not exist "eula.txt" (
    echo First time setup: Accepting EULA...
    echo eula=true > eula.txt
    echo EULA has been accepted. Please review eula.txt and restart the server.
    pause
    exit /b 0
)

:: Start the server
echo.
echo Minecraft Forge Server
echo =====================
echo Min RAM: %MIN_RAM%
echo Max RAM: %MAX_RAM%
echo Server Jar: %SERVER_JAR%
echo.

java -Xms%MIN_RAM% -Xmx%MAX_RAM% -jar "%SERVER_JAR%" nogui

echo.
echo Server stopped. Press any key to exit...
pause