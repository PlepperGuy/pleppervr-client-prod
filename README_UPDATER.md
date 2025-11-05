# PlepperVR Auto-Updater

This directory contains batch scripts that automatically download the latest mrpack from the production repository and update your Prism Launcher instance while preserving your user configurations.

## Files

- **`update_and_launch.bat`** - Main updater script (recommended)
- **`update_and_launch_advanced.bat`** - Advanced version with additional features
- **`updater_config.bat`** - Configuration file for customizing settings
- **`README_UPDATER.md`** - This documentation file

## Quick Start

1. **Configure the settings** in `updater_config.bat` if needed
2. **Run the updater** by double-clicking `update_and_launch.bat`
3. **Wait for the process** to complete - it will automatically launch the game

## Configuration

Edit `updater_config.bat` to customize:

### Basic Settings
- `REPO_OWNER` - GitHub repository owner (default: `PlepperGuy`)
- `REPO_NAME` - GitHub repository name (default: `pleppervr-client-production`)
- `INSTANCE_NAME` - Prism Launcher instance name (default: `PlepperVR_Test`)
- `PRISM_LAUNCHER` - Path to Prism Launcher executable
- `PRISM_DATA_DIR` - Path to Prism Launcher data directory

### Update Behavior
- `ENABLE_BACKUP` - Set to `true` to backup/restore user configs (recommended: `true`)
- `LAUNCH_AFTER_UPDATE` - Set to `true` to auto-launch game after update (recommended: `true`)
- `SKIP_UPDATE_IF_CURRENT` - Set to `true` to skip if already on latest version (recommended: `true`)

### Backup Items
The `BACKUP_ITEMS` variable controls what gets backed up and restored:
- `options.txt` - Game settings and controls
- `config` - Mod configuration files
- `saves` - World saves
- `resourcepacks` - Custom resource packs
- `shaderpacks` - Custom shader packs
- `screenshots` - In-game screenshots
- `instance.cfg` - Instance configuration

## What the Script Does

1. **Fetches latest release** from GitHub API
2. **Downloads the mrpack** file from the latest release
3. **Backs up user configurations** (if enabled)
4. **Imports the mrpack** into Prism Launcher
5. **Restores user configurations** (if backup was created)
6. **Launches the game** automatically (if enabled)

## Safety Features

- **Configuration backup** - Preserves your settings, saves, and custom content
- **Error handling** - Graceful handling of network issues and import failures
- **Logging** - Detailed log file created in temporary directory
- **Verification** - Checks for required files and permissions
- **Cleanup** - Automatically removes temporary files

## Troubleshooting

### Common Issues

**"Configuration file not found"**
- Ensure `updater_config.bat` exists in the same directory as the main script

**"Prism Launcher not found"**
- Check the `PRISM_LAUNCHER` path in `updater_config.bat`
- Update it to your actual Prism Launcher installation path

**"Failed to fetch release information"**
- Check your internet connection
- Verify the repository name and owner are correct
- Ensure the repository has a public release with an mrpack file

**"Failed to import mrpack file"**
- Ensure Prism Launcher is not running during the update
- Check if you have sufficient disk space
- Verify the downloaded mrpack file is not corrupted

**"Failed to launch game"**
- The update completed but automatic launch failed
- Launch the game manually from Prism Launcher
- Check if the instance name is correct in configuration

### Manual Recovery

If something goes wrong, your backed up files are temporarily stored in:
```
%TEMP%\PlepperVR_Update\config_backup\
```

This directory is automatically cleaned up after each run, so if you need to recover files, copy them before running the script again.

## Advanced Version

The `update_and_launch_advanced.bat` script includes additional features:
- More detailed logging
- Version comparison to skip unnecessary updates
- Enhanced error messages with colors
- Progress indicators for each step
- More robust PowerShell error handling

## Requirements

- Windows 10 or later
- Prism Launcher installed
- Internet connection for downloading updates
- PowerShell (included with Windows)
- Sufficient disk space for the download and backup

## Security Notes

- The script only downloads from the configured GitHub repository
- All downloads are verified through the GitHub API
- Temporary files are cleaned up automatically
- No personal data is transmitted - only GitHub API calls

## Support

For issues with:
- **The updater script**: Check this README and troubleshooting section
- **The modpack itself**: Contact the modpack maintainer
- **Prism Launcher**: Refer to Prism Launcher documentation

---

**Note**: This updater is designed specifically for the PlepperVR modpack and repository structure.