# ============================================================================
# PS2EXE Compilation Script for PlepperVR Updater
# ============================================================================
# This script compiles the PowerShell updater into a standalone executable
# ============================================================================

# Configuration
$PSScriptPath = "PlepperVR_Updater.ps1"
$OutputEXE = "PlepperVR_Updater.exe"
$IconFile = $null  # Set to icon file path if you have one

# Check if PS2EXE module is installed
function Install-PS2EXE {
    Write-Host "PS2EXE module not found. Installing..." -ForegroundColor Yellow
    try {
        Install-Module -Name PS2EXE -Scope CurrentUser -Force
        Write-Host "PS2EXE module installed successfully!" -ForegroundColor Green
        return $true
    } catch {
        Write-Host "Failed to install PS2EXE module: $_" -ForegroundColor Red
        Write-Host "Please install manually: Install-Module -Name PS2EXE -Scope CurrentUser" -ForegroundColor Red
        return $false
    }
}

# Main compilation function
function Start-Compilation {
    param(
        [string]$SourceScript,
        [string]$OutputFile,
        [string]$IconPath = $null
    )

    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "PlepperVR Updater Compilation" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "Source: $SourceScript"
    Write-Host "Output: $OutputFile"
    Write-Host ""

    # Check if source script exists
    if (!(Test-Path $SourceScript)) {
        Write-Host "ERROR: Source script not found: $SourceScript" -ForegroundColor Red
        return $false
    }

    # Import PS2EXE module
    try {
        Import-Module PS2EXE -Force
    } catch {
        if (!(Install-PS2EXE)) {
            return $false
        }
        try {
            Import-Module PS2EXE -Force
        } catch {
            Write-Host "ERROR: Failed to import PS2EXE module" -ForegroundColor Red
            return $false
        }
    }

    # Build parameters for PS2EXE
    $ps2exeParams = @{
        inputFile  = $SourceScript
        outputFile = $OutputFile
        noConsole  = $false  # Keep console window for better debugging
        architecture = "x64"
        framework = "net4.8"
        title = "PlepperVR Auto-Updater"
        description = "PlepperVR Modpack Auto-Updater and Launcher"
        company = "PlepperVR"
        product = "PlepperVR Updater"
        copyright = "(c) PlepperVR Team"
        version = "1.0.0.0"
        verbose = $true
    }

    # Add icon if specified
    if ($IconPath -and (Test-Path $IconPath)) {
        $ps2exeParams.iconFile = $IconPath
        Write-Host "Using icon: $IconPath" -ForegroundColor Green
    }

    # Compile the executable
    try {
        Write-Host "Starting compilation..." -ForegroundColor Yellow
        ps2exe @ps2exeParams

        if (Test-Path $OutputFile) {
            $fileInfo = Get-Item $OutputFile
            Write-Host ""
            Write-Host "========================================" -ForegroundColor Green
            Write-Host "Compilation Successful!" -ForegroundColor Green
            Write-Host "========================================" -ForegroundColor Green
            Write-Host "Output file: $OutputFile" -ForegroundColor White
            Write-Host "File size: $([math]::Round($fileInfo.Length / 1MB, 2)) MB" -ForegroundColor White
            Write-Host "Created: $($fileInfo.CreationTime)" -ForegroundColor White
            Write-Host ""
            Write-Host "You can now distribute this executable to users!" -ForegroundColor Cyan
            return $true
        } else {
            Write-Host "ERROR: Compilation failed - no output file created" -ForegroundColor Red
            return $false
        }
    } catch {
        Write-Host "ERROR: Compilation failed: $_" -ForegroundColor Red
        return $false
    }
}

# Alternative compilation method using PowerShell App Deployment Toolkit
function Start-AlternativeCompilation {
    param(
        [string]$SourceScript,
        [string]$OutputFile
    )

    Write-Host "Trying alternative compilation method..." -ForegroundColor Yellow

    try {
        # Create a simple wrapper script
        $wrapperScript = @"
# PowerShell wrapper for PlepperVR Updater
try {
    # Extract embedded script and run it
    $scriptPath = Join-Path `$env:TEMP 'PlepperVR_Updater.ps1'

    # In a real implementation, the script would be embedded as a resource
    # For now, we'll use a different approach

    # Start PowerShell with the original script
    Start-Process -FilePath 'powershell.exe' -ArgumentList @(
        '-ExecutionPolicy', 'Bypass',
        '-File', "`"$PSScriptRoot\$SourceScript`""
    ) -Wait
} catch {
    Write-Host "Error: `$_" -ForegroundColor Red
    Start-Sleep -Seconds 5
}
"@

        # This is a placeholder for a more complex solution
        Write-Host "Note: For a true standalone executable, consider using:" -ForegroundColor Yellow
        Write-Host "1. PS2EXE-GUI (GUI version of PS2EXE)" -ForegroundColor White
        Write-Host "2. PowerShell App Deployment Toolkit" -ForegroundColor White
        Write-Host "3. Commercial tools like PowerBuilder" -ForegroundColor White
        Write-Host "4. Convert to C#/.NET application" -ForegroundColor White

        return $false
    } catch {
        return $false
    }
}

# Main execution
try {
    $success = Start-Compilation -SourceScript $PSScriptPath -OutputFile $OutputEXE -IconPath $IconFile

    if (!$success) {
        Write-Host ""
        Write-Host "Primary compilation method failed. Trying alternatives..." -ForegroundColor Yellow
        $success = Start-AlternativeCompilation -SourceScript $PSScriptPath -OutputFile $OutputEXE
    }

    if (!$success) {
        Write-Host ""
        Write-Host "Compilation failed. Manual setup options:" -ForegroundColor Red
        Write-Host "1. Install PS2EXE: Install-Module -Name PS2EXE -Scope CurrentUser" -ForegroundColor White
        Write-Host "2. Use PS2EXE-GUI for a graphical interface" -ForegroundColor White
        Write-Host "3. Use the original .bat files as an alternative" -ForegroundColor White
    }

    Write-Host ""
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

} catch {
    Write-Host "Fatal error during compilation: $_" -ForegroundColor Red
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}