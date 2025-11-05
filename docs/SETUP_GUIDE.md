# PlepperVR Client Setup Guide

This guide covers the complete setup process for the PlepperVR modpack client.

## Prerequisites

- Prism Launcher installed
- Git installed
- At least 4GB of RAM available (8GB recommended)

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/PlepperGuy/pleppervr-client-testing.git
cd pleppervr-client-testing
```

### 2. Set up Prism Launcher Instance

1. Open Prism Launcher
2. Click "Add Instance"
3. Select "Import from zip" and choose the `PlepperVR_Test.mrpack` file from the repository
4. If no zip is provided, create a new instance manually:
   - Name: PlepperVR_Test
   - Version: 1.20.1
   - Modloader: Forge 47.2.20
5. Right-click the instance, select "Edit", go to the "Settings" tab
6. Change the Instance Folder to the cloned `pleppervr-client-testing` directory
7. Allocate 4GB-8GB of RAM under the "Java" tab

### 3. Install Mods with mmm

From your terminal, ensure you are in the `pleppervr-client-testing` directory:

```bash
# Install all mods from modlist.json
./mmm.exe install
```

### 4. Launch the Instance

1. In Prism Launcher, select the PlepperVR_Test instance
2. Click "Launch"
3. Verify all mods load correctly
4. Check for crashes and performance issues

## Troubleshooting

### Common Issues

1. **Out of Memory Errors**: Increase RAM allocation in Prism Launcher settings
2. **Mod Loading Failures**: Run `./mmm.exe install` again to ensure all mods are properly downloaded
3. **VR Issues**: Ensure Vivecraft is properly installed and configured

### Getting Help

- Check the logs in the `minecraft/logs/` directory
- Refer to the main documentation in `CLAUDE.md`
- Create an issue on the GitHub repository