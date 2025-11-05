#!/bin/bash

echo "Starting Minecraft Forge Server..."

# Configuration
MIN_RAM="4G"
MAX_RAM="8G"
SERVER_JAR="forge-1.20.1-47.2.20.jar"

# Check if Java is available
if ! command -v java &> /dev/null; then
    echo "Error: Java is not installed or not in PATH"
    echo "Please install Java 17 or higher and try again"
    exit 1
fi

# Check if server jar exists
if [ ! -f "$SERVER_JAR" ]; then
    echo "Error: Server jar file not found: $SERVER_JAR"
    echo "Please ensure Forge server is properly installed"
    exit 1
fi

# Check if EULA is accepted
if [ ! -f "eula.txt" ]; then
    echo "First time setup: Accepting EULA..."
    echo "eula=true" > eula.txt
    echo "EULA has been accepted. Please review eula.txt and restart the server."
    exit 0
fi

# Start the server
echo ""
echo "Minecraft Forge Server"
echo "====================="
echo "Min RAM: $MIN_RAM"
echo "Max RAM: $MAX_RAM"
echo "Server Jar: $SERVER_JAR"
echo ""

java -Xms$MIN_RAM -Xmx$MAX_RAM -jar "$SERVER_JAR" nogui